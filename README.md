# ArabicHub

#### Video Demo: https://youtu.be/PQuJuipQQAw

#### Description:

ArabicHub is a web application that teaches absolute beginners to read Arabic. It is built with Flask, SQLite and Jinja templates, and it takes a learner from not recognising a single character through to reading short vocabulary with the correct short vowels.

Most language apps aimed at English speakers start with phrases: "hello", "thank you", "where is the station". That works for Spanish or French, where the learner can already read the alphabet. It does not work for Arabic. A beginner who is handed the phrase مرحبا cannot read it, cannot sound it out, and ends up memorising a picture of a word rather than learning the script. ArabicHub is built around the opposite assumption: the script comes first, everything else comes after.

That single decision shapes the whole application. The Arabic alphabet is not treated as one lesson among five. It is a dedicated learning track with its own page for every one of the 28 letters, its own navigation, and its own per-letter progress tracking. The four vocabulary lessons that follow are tracked as whole units, because there is no pedagogical value in recording that a learner has seen 6 of 11 greetings, whereas there is real value in recording exactly which letters they have studied.

**The alphabet track.** Each letter gets a full page showing the character at 120px, its name, an approximate English sound, and a table of its four positional forms. This last part matters more than it might seem. Arabic letters change shape depending on whether they appear at the start, middle or end of a word, and this is the single biggest source of confusion for new readers — ب, بـ, ـبـ and ـب are all the same letter. Showing all four side by side on every letter page turns that from a nasty surprise into an expected pattern. Each page also carries an example word with its English meaning and a play button, so the letter is immediately seen inside a real word rather than in isolation.

**Audio.** Every letter has recorded pronunciation, as does every example word. Arabic contains sounds with no English equivalent — ع, ح, ق and the emphatic letters ص ض ط ظ have no way of being conveyed by transliteration alone. A learner reading "Emphatic S" on a page has learned nothing. The audio was pre-generated with Microsoft Edge's neural text-to-speech voices using the two scripts described below, then committed to the repository as static files. This was a deliberate choice over calling a TTS service at request time: the audio never changes, generating it once keeps every page load fast, and it means the application has no external API dependency and works with no network connection.

**Progress tracking.** The dashboard shows two figures: alphabet progress as a count of letters completed out of 28, and an overall percentage across all learning material. Letters are counted individually while vocabulary lessons are counted as units, so the overall total is 28 letters plus the 4 non-alphabet lessons, giving 32 items. The Alphabet lesson is deliberately excluded from that count on the lesson side, because its 28 letters are already counted one by one — counting it again would let the total exceed 100%.

**The quiz.** Questions are generated at random rather than stored, drawing from a pool made up of every alphabet letter, every harakat example and all 42 vocabulary words. A round is five questions. Because several study items legitimately share an English meaning — three different letters all demonstrate "Fatha (a)" — the three wrong choices are de-duplicated by meaning before the question is assembled, so the correct answer can never appear twice in the same list. The answer to the current question is held in the server-side session rather than in a hidden form field, so it cannot be read or edited from the browser. Completed rounds are written to the database and the results page shows previous attempts.

**Favourites.** Any vocabulary word can be starred from its lesson and collected on a single Favorites page, grouped by lesson, so a learner can build their own revision list rather than re-reading whole lessons.

## Files

**`app.py`** — the entire Flask application: configuration, the database connection, and all seventeen routes. Beyond the route handlers it contains three helper functions. `get_letters()` reads the `letters` table and attaches the correct audio filename to each row, so the audio mapping lives in one place instead of being repeated in templates. `mark_lesson_completed()` marks a lesson complete for a user; it checks for an existing row and updates it, falling back to an insert, because `register()` pre-creates a progress row for every lesson and a plain insert would collide with the table's unique constraint and silently do nothing. `build_question()` assembles one quiz question with de-duplicated distractors.

**`helpers.py`** — the `login_required` decorator, which redirects anyone without a `user_id` in their session to the login page. Every route that touches user data is wrapped in it.

**`schema.sql`** — all nine table definitions with comments, written so the database can be rebuilt from scratch with `sqlite3 arabic.db < schema.sql`. The tables are `users`, `lessons`, `letters`, `lesson_items`, `vocabulary`, `favorites`, `user_progress`, `letter_progress` and `quiz_results`.

**`seed.sql`** — all of the lesson content: the 5 lessons, the 28 letters with their positional forms and audio filenames, 67 lesson items covering the alphabet and the harakat, and 42 vocabulary words. Running this after `schema.sql` reproduces a complete, working database. No user data is seeded; that is created by the application at runtime.

**`arabic.db`** — the SQLite database file.

**`templates/layout.html`** — the base template every other page extends. Holds the navigation bar, which changes depending on whether a user is logged in, and the flash message area, which renders errors in red and everything else in green.

**`templates/index.html`** — the public landing page.

**`templates/register.html`** and **`templates/login.html`** — the account forms.

**`templates/dashboard.html`** — the logged-in home page: cards for the alphabet, vocabulary and harakat tracks, the quiz, and two progress bars.

**`templates/lessons.html`** — lists all five lessons with their vocabulary counts, showing "Review Lesson" for completed ones and "Start Lesson" otherwise.

**`templates/lesson.html`** — renders a single vocabulary lesson as a grid of cards with favourite buttons.

**`templates/alphabet.html`** — the grid of all 28 letters, linking to each letter page.

**`templates/letter.html`** — the individual letter page: the character, its positional forms table, audio buttons, the example word, previous/next navigation and the completion button.

**`templates/quiz.html`** — one quiz question with four choices, the question counter, running score and progress bar.

**`templates/quiz_result.html`** — the end-of-round score with a table of previous attempts.

**`templates/favorites.html`** — saved vocabulary grouped by lesson.

**`static/css/style.css`** — custom styling on top of Bootstrap 5, mainly for the Arabic type. Arabic is set in the Cairo font, since Bootstrap's default stack renders Arabic poorly at large sizes.

**`static/audio/alphabet/`** — 141 audio files covering each letter's name and sound.

**`static/audio/examples/`** — 28 recordings of the example words.

**`create_audio.py`** and **`create_examples_audio.py`** — one-off scripts using the `edge_tts` library to generate the letter and example-word audio with an Arabic neural voice. They are not part of the running application and do not need to be run again; they are included so the audio can be regenerated or extended.

**`requirements.txt`** — Flask, Flask-Session, cs50 and Werkzeug.

## Design decisions

**Why two tables for the alphabet.** `lesson_items` holds the 28 letters as generic study items so the quiz can draw from one uniform pool alongside the harakat, while `letters` holds the rich per-letter detail — the four positional forms, two audio filenames, an example word and its translation. Folding these into one table would have meant a dozen columns sitting empty for every non-letter row.

**Why the quiz answer lives in the session.** Putting it in a hidden input would have been simpler, but anyone could read it with View Source and score perfectly. Keeping it server-side means the browser only ever sees four indistinguishable choices.

**Why SQLite.** The dataset is small, fixed and read-heavy — 142 rows of lesson content that never change at runtime. A file-based database keeps the whole project self-contained with no server to configure, which matters for something a grader should be able to clone and run in under a minute.

**Why pre-generated audio.** Discussed above: speed, no API dependency, and it works offline.

## Running the application

```
pip install -r requirements.txt
flask run
```

To rebuild the database from scratch:

```
sqlite3 arabic.db < schema.sql
sqlite3 arabic.db < seed.sql
```

Then open the application in a browser and register an account.

## Future improvements

- Writing practice, tracing each letter's four forms
- Quizzes scoped to a single lesson rather than the whole pool
- Spaced repetition over the favourites list
- Listening exercises that play a sound and ask the learner to pick the letter

## AI Assistance

Claude (Anthropic) was used as a debugging and review assistant on this project. The specific contributions are documented in the disclosure comment at the top of app.py.
