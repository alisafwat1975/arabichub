# ---------------------------------------------------------------------
# AI assistance (per CS50 final project policy)
#
# Claude (Anthropic) was used for debugging and code review:
#   - fixed the lesson-completion bug in complete_letter() and the
#     double-counting bug in the dashboard progress calculation
#   - added the missing url_for import
#   - implemented the quiz: build_question(), quiz(), quiz_answer(),
#     quiz_result(), quiz.html and quiz_result.html
#   - added mark_lesson_completed(); fixed flash handling in login()
#   - regenerated schema.sql and seed.sql
#   - drafted README.md
#
# The concept, database design, lesson content and Arabic audio are my
# own work.
# ---------------------------------------------------------------------

import random

from cs50 import SQL

from flask import (
    Flask,
    flash,
    redirect,
    render_template,
    request,
    session,
    url_for,
)

from flask_session import Session

from werkzeug.security import (
    check_password_hash,
    generate_password_hash,
)

from helpers import login_required

app = Flask(__name__)

app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"

Session(app)

db = SQL("sqlite:///arabic.db")

# Number of questions in one round of the quiz.
QUIZ_LENGTH = 5


@app.after_request
def after_request(response):
    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    response.headers["Expires"] = 0
    response.headers["Pragma"] = "no-cache"
    return response
def get_letters():

    audio_map = {
        "Alif": "alif.mp3",
        "Ba": "baa.mp3",
        "Ta": "taa.mp3",
        "Tha": "thaa.mp3",
        "Jeem": "jeem.mp3",
        "Ha": "haa.mp3",
        "Kha": "khaa.mp3",
        "Dal": "daal.mp3",
        "Dhal": "thaal.mp3",
        "Ra": "raa.mp3",
        "Zay": "zaay.mp3",
        "Seen": "seen.mp3",
        "Sheen": "sheen.mp3",
        "Sad": "saad.mp3",
        "Dad": "daad.mp3",
        "Ta emphatic": "taa_emphatic.mp3",
        "Dha": "thaa_emphatic.mp3",
        "Ayn": "ayn.mp3",
        "Ghayn": "ghayn.mp3",
        "Fa": "faa.mp3",
        "Qaf": "qaaf.mp3",
        "Kaf": "kaaf.mp3",
        "Lam": "laam.mp3",
        "Meem": "meem.mp3",
        "Noon": "noon.mp3",
        "Ha": "haa.mp3",
        "Waw": "waaw.mp3",
        "Ya": "yaa.mp3"
    }

    rows = db.execute("""
        SELECT *
        FROM letters
        ORDER BY id
    """)

    letters = []

    for row in rows:
        letters.append({
            "letter": row["letter"],
            "name": row["name"],
            "sound": row["sound"],
            "audio": audio_map[row["name"]],
            "isolated": row["isolated"],
            "beginning": row["beginning"],
            "middle": row["middle"],
            "end": row["end"],
            "example": row["example"],
            "example_english": row["example_english"],
            "example_audio": audio_map[row["name"]].replace(".mp3", "") + ".mp3",
            "name_audio": row["name_audio"],
            "sound_audio": row["sound_audio"]
        })

    return letters


def mark_lesson_completed(user_id, lesson_id):
    """
    Mark a lesson as completed for a user.

    register() pre-creates a user_progress row for every lesson with
    completed = 0, so a plain INSERT would collide with the
    UNIQUE(user_id, lesson_id) constraint. Update the existing row when
    there is one, and insert only when there is not.
    """

    existing = db.execute(
        """
        SELECT id
        FROM user_progress
        WHERE user_id = ?
        AND lesson_id = ?
        """,
        user_id,
        lesson_id
    )

    if existing:

        db.execute(
            """
            UPDATE user_progress
            SET completed = 1
            WHERE user_id = ?
            AND lesson_id = ?
            """,
            user_id,
            lesson_id
        )

    else:

        db.execute(
            """
            INSERT INTO user_progress
            (user_id, lesson_id, completed)
            VALUES (?, ?, 1)
            """,
            user_id,
            lesson_id
        )


@app.route("/")
def index():
    return render_template("index.html")


@app.route("/register", methods=["GET", "POST"])
def register():

    if request.method == "POST":

        username = request.form.get("username")
        password = request.form.get("password")
        confirmation = request.form.get("confirmation")

        if not username:
            flash("Username required", "error")
            return redirect("/register")

        if not password:
            flash("Password required", "error")
            return redirect("/register")

        if password != confirmation:
            flash("Passwords do not match", "error")
            return redirect("/register")

        rows = db.execute(
            "SELECT * FROM users WHERE username = ?",
            username
        )

        if rows:
            flash("Username already exists", "error")
            return redirect("/register")

        hash_password = generate_password_hash(password)

        user_id = db.execute(
            "INSERT INTO users (username, hash) VALUES (?, ?)",
            username,
            hash_password
        )

        lessons = db.execute(
            "SELECT id FROM lessons"
        )

        for lesson in lessons:
            db.execute(
                """
                INSERT INTO user_progress (user_id, lesson_id, completed)
                VALUES (?, ?, 0)
                """,
                user_id,
                lesson["id"]
            )

        flash("Registration successful. Please log in.")
        return redirect("/login")

    return render_template("register.html")


@app.route("/login", methods=["GET", "POST"])
def login():

    if request.method == "POST":

        username = request.form.get("username")
        password = request.form.get("password")

        rows = db.execute(
            "SELECT * FROM users WHERE username = ?",
            username
        )

        if len(rows) != 1 or not check_password_hash(rows[0]["hash"], password):
            flash("Invalid username or password", "error")
            return redirect("/login")

        # Start a clean session, but only once the credentials check out.
        # Clearing at the top of this route would also wipe any pending
        # flash message, so the user would never find out why a login
        # failed or that their registration succeeded.
        session.clear()
        session["user_id"] = rows[0]["id"]

        return redirect("/dashboard")

    # Opening the login page logs out whoever is currently signed in, so
    # it always means "sign in as someone". Pending flash messages are
    # carried across the clear, otherwise the reason a login failed
    # would be wiped before it could ever be shown.
    pending_messages = session.pop("_flashes", None)

    session.clear()

    if pending_messages:
        session["_flashes"] = pending_messages

    return render_template("login.html")


@app.route("/logout")
def logout():
    session.clear()
    return redirect("/login")
@app.route("/dashboard")
@login_required
def dashboard():

    user_id = session["user_id"]

    total_lessons = db.execute(
        "SELECT COUNT(*) AS count FROM lessons"
    )[0]["count"]

    # Lesson 1 is the alphabet, which is already counted letter by letter
    # below. Excluding it here keeps it from being counted twice.
    completed_vocabulary_lessons = db.execute(
        """
        SELECT COUNT(*) AS count
        FROM user_progress
        WHERE user_id = ?
        AND completed = 1
        AND lesson_id != 1
        """,
        user_id
    )[0]["count"]


    total_letters = db.execute(
        """
        SELECT COUNT(*) AS count
        FROM lesson_items
        WHERE lesson_id = 1
        """
    )[0]["count"]


    completed_letters = db.execute(
        """
        SELECT COUNT(*) AS count
        FROM letter_progress
        WHERE user_id = ?
        AND completed = 1
        """,
        user_id
    )[0]["count"]


    if total_letters > 0:
        alphabet_progress = round(
            (completed_letters / total_letters) * 100
        )
    else:
        alphabet_progress = 0


    # 28 letters plus every lesson except the alphabet one.
    total_learning_items = total_letters + (total_lessons - 1)

    completed_learning_items = (
        completed_letters + completed_vocabulary_lessons
    )

    if total_learning_items > 0:
        progress = round(
            (completed_learning_items / total_learning_items) * 100
        )
    else:
        progress = 0


    completed_ids = [
        row["lesson_id"]
        for row in db.execute(
            """
            SELECT lesson_id
            FROM user_progress
            WHERE user_id = ?
            AND completed = 1
            """,
            user_id
        )
    ]

    return render_template(
        "dashboard.html",
        progress=progress,
        alphabet_progress=alphabet_progress,
        completed_letters=completed_letters,
        total_letters=total_letters,
        completed_ids=completed_ids
    )

@app.route("/favorites")
@login_required
def favorites():

    favorites = db.execute(
        """
        SELECT
            vocabulary.id,
            vocabulary.arabic,
            vocabulary.transliteration,
            vocabulary.english,
            lessons.title
        FROM favorites
        JOIN vocabulary
            ON favorites.vocabulary_id = vocabulary.id
        JOIN lessons
            ON vocabulary.lesson_id = lessons.id
        WHERE favorites.user_id = ?
        ORDER BY lessons.sort_order, vocabulary.id
        """,
        session["user_id"]
    )

    return render_template(
        "favorites.html",
        favorites=favorites
    )





@app.route("/lessons")
@login_required
def lessons():

    lessons = db.execute(
        """
        SELECT
            lessons.*,
            (
                SELECT COUNT(*)
                FROM vocabulary
                WHERE vocabulary.lesson_id = lessons.id
            ) AS vocabulary_count
        FROM lessons
        ORDER BY sort_order
        """
    )
    completed_lessons = []

    if "user_id" in session:
        completed_lessons = db.execute(
            """
            SELECT lesson_id
            FROM user_progress
            WHERE user_id = ?
            AND completed = 1
            """,
            session["user_id"]
        )

        completed_lessons = [
            row["lesson_id"]
            for row in completed_lessons
        ]

    return render_template(
        "lessons.html",
        lessons=lessons,
        completed_lessons=completed_lessons
    )



@app.route("/lesson/<int:lesson_id>")
@login_required
def lesson(lesson_id):

    lesson = db.execute(
        "SELECT * FROM lessons WHERE id = ?",
        lesson_id
    )

    if not lesson:
        return redirect("/lessons")

    if lesson_id == 1:
        items = db.execute(
            """
            SELECT *
            FROM lesson_items
            WHERE lesson_id = ?
            ORDER BY sort_order
            """,
            lesson_id
        )
    else:
        items = db.execute(
            """
            SELECT
                id,
                arabic,
                transliteration,
                english,
                'Vocabulary' AS item_type
            FROM vocabulary
            WHERE lesson_id = ?
            ORDER BY id
            """,
            lesson_id
        )

    favorite_ids = {
        row["vocabulary_id"]
        for row in db.execute(
            """
            SELECT vocabulary_id
            FROM favorites
            WHERE user_id = ?
            """,
            session["user_id"]
        )
    }

    return render_template(
        "lesson.html",
        lesson=lesson[0],
        items=items,
        favorite_ids=favorite_ids
    )


@app.route("/lessons/alphabet")
@login_required
def alphabet():

    return render_template(
        "alphabet.html",
        letters=get_letters()
    )


@app.route("/lessons/alphabet/<int:number>")
@login_required
def alphabet_letter(number):

    letters = get_letters()

    if number < 1 or number > len(letters):
        return redirect("/lessons/alphabet")


    return render_template(
        "letter.html",
        letter=letters[number - 1],
        number=number,
        total=len(letters)
    )




@app.route("/complete-letter/<int:number>", methods=["POST"])
@login_required
def complete_letter(number):

    user_id = session["user_id"]

    total_letters = len(get_letters())

    db.execute(
        """
        INSERT OR IGNORE INTO letter_progress
        (user_id, letter_id, completed)
        VALUES (?, ?, 1)
        """,
        user_id,
        number
    )

    completed_letters = db.execute(
        """
        SELECT COUNT(*) AS count
        FROM letter_progress
        WHERE user_id = ?
        AND completed = 1
        """,
        user_id
    )[0]["count"]

    # Mark the Alphabet lesson complete once every letter is done, no
    # matter which order the user studied them in.
    if completed_letters >= total_letters:
        mark_lesson_completed(user_id, 1)

    if number >= total_letters:
        return redirect("/dashboard")

    return redirect(f"/lessons/alphabet/{number + 1}")


def build_question():
    """
    Build one multiple choice question.

    The pool is every alphabet letter and harakat item plus every
    vocabulary word. Several items share an english meaning (three
    different letters all demonstrate "Fatha (a)", for example), so the
    distractors are de-duplicated by meaning. Without that the correct
    answer could appear in the choice list two or three times.
    """

    pool = db.execute(
        """
        SELECT arabic, english FROM lesson_items
        UNION
        SELECT arabic, english FROM vocabulary
        """
    )

    item = random.choice(pool)

    distractors = sorted({
        row["english"]
        for row in pool
        if row["english"] != item["english"]
    })

    choices = random.sample(distractors, 3)
    choices.append(item["english"])
    random.shuffle(choices)

    return {
        "text": f"What is the meaning of {item['arabic']}?",
        "choices": choices,
        "answer": item["english"]
    }


@app.route("/quiz")
@login_required
def quiz():
    """
    Show the current question, starting a new round when there is not
    one already in progress.
    """

    if "quiz_number" not in session:
        session["quiz_number"] = 1
        session["quiz_score"] = 0

    question = build_question()

    # The answer is kept in the session rather than in a hidden form
    # field so that it cannot be read or edited in the browser.
    session["quiz_answer"] = question["answer"]

    return render_template(
        "quiz.html",
        question=question,
        number=session["quiz_number"],
        total=QUIZ_LENGTH,
        score=session["quiz_score"]
    )


@app.route("/quiz/answer", methods=["POST"])
@login_required
def quiz_answer():
    """
    Grade the submitted choice, then move on to the next question or to
    the results page once the round is over.
    """

    answer = session.get("quiz_answer")

    # No question in progress, so there is nothing to grade.
    if answer is None:
        return redirect("/quiz")

    choice = request.form.get("choice")

    if choice == answer:
        session["quiz_score"] = session.get("quiz_score", 0) + 1
        flash(f"Correct! {answer}")
    else:
        flash(f"Not quite. The answer was: {answer}", "error")

    session["quiz_number"] = session.get("quiz_number", 1) + 1
    session.pop("quiz_answer", None)

    if session["quiz_number"] > QUIZ_LENGTH:

        db.execute(
            """
            INSERT INTO quiz_results (user_id, score, total)
            VALUES (?, ?, ?)
            """,
            session["user_id"],
            session.get("quiz_score", 0),
            QUIZ_LENGTH
        )

        session.pop("quiz_number", None)
        session.pop("quiz_score", None)

        return redirect("/quiz/result")

    return redirect("/quiz")


@app.route("/quiz/result")
@login_required
def quiz_result():
    """
    Show the score for the round that just finished, plus recent
    attempts. This reads from the database rather than writing to it,
    so refreshing the page does not record an extra result.
    """

    results = db.execute(
        """
        SELECT score, total, completed_at
        FROM quiz_results
        WHERE user_id = ?
        ORDER BY id DESC
        LIMIT 6
        """,
        session["user_id"]
    )

    if not results:
        return redirect("/quiz")

    return render_template(
        "quiz_result.html",
        latest=results[0],
        recent=results[1:]
    )





@app.route("/complete-lesson/<int:lesson_id>", methods=["POST"])
@login_required
def complete_lesson(lesson_id):

    mark_lesson_completed(session["user_id"], lesson_id)

    return redirect("/dashboard")



@app.route("/favorite/<int:vocabulary_id>", methods=["POST"])
@login_required
def add_favorite(vocabulary_id):

    db.execute(
        """
        INSERT OR IGNORE INTO favorites
        (user_id, vocabulary_id)
        VALUES (?, ?)
        """,
        session["user_id"],
        vocabulary_id
    )

    return redirect(request.referrer or url_for("favorites"))


@app.route("/unfavorite/<int:vocabulary_id>", methods=["POST"])
@login_required
def remove_favorite(vocabulary_id):

    db.execute(
        """
        DELETE FROM favorites
        WHERE user_id = ?
        AND vocabulary_id = ?
        """,
        session["user_id"],
        vocabulary_id
    )

    return redirect(request.referrer or url_for("favorites"))


if __name__ == "__main__":
    app.run(debug=True)

