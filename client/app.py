import os
from datetime import date

from flask import Flask, redirect, render_template, request, url_for
import psycopg
from psycopg.rows import dict_row

app = Flask(__name__)


def get_connection():
    return psycopg.connect(
        host=os.getenv("DB_HOST", "db"),
        port=int(os.getenv("DB_PORT", "5432")),
        dbname=os.getenv("DB_NAME", "warehouse"),
        user=os.getenv("DB_USER", "warehouse_user"),
        password=os.getenv("DB_PASSWORD", "warehouse_pass"),
        row_factory=dict_row,
    )


@app.get("/")
def index():
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                SELECT i.id, i.sku, i.name, i.quantity, i.unit, i.location,
                       COALESCE(MAX(m.created_at::date), CURRENT_DATE) AS last_move
                FROM items i
                LEFT JOIN movements m ON m.item_id = i.id
                GROUP BY i.id
                ORDER BY i.name;
                """
            )
            items = cur.fetchall()

            cur.execute(
                """
                SELECT m.id, i.name AS item_name, m.move_type, m.amount, m.created_at::date AS created_at
                FROM movements m
                JOIN items i ON i.id = m.item_id
                ORDER BY m.created_at DESC
                LIMIT 8;
                """
            )
            movements = cur.fetchall()

    return render_template("index.html", items=items, movements=movements, today=date.today())


@app.post("/move")
def move_item():
    item_id = int(request.form["item_id"])
    amount = int(request.form["amount"])
    move_type = request.form["move_type"]

    if amount <= 0 or move_type not in {"in", "out"}:
        return redirect(url_for("index"))

    delta = amount if move_type == "in" else -amount

    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("UPDATE items SET quantity = GREATEST(0, quantity + %s) WHERE id = %s", (delta, item_id))
            cur.execute(
                "INSERT INTO movements (item_id, move_type, amount) VALUES (%s, %s, %s)",
                (item_id, move_type, amount),
            )
        conn.commit()

    return redirect(url_for("index"))


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
