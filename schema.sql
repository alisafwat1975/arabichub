-- =====================================================
-- ArabicHub
-- Database Schema
--
-- Rebuild the database from scratch with:
--     sqlite3 arabic.db < schema.sql
--     sqlite3 arabic.db < seed.sql
-- =====================================================

DROP TABLE IF EXISTS quiz_results;
DROP TABLE IF EXISTS letter_progress;
DROP TABLE IF EXISTS user_progress;
DROP TABLE IF EXISTS favorites;
DROP TABLE IF EXISTS vocabulary;
DROP TABLE IF EXISTS lesson_items;
DROP TABLE IF EXISTS letters;
DROP TABLE IF EXISTS lessons;
DROP TABLE IF EXISTS users;


-- Registered accounts.
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL UNIQUE,
    hash TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- The five top level lessons. Lesson 1 is the alphabet, which is
-- tracked letter by letter; the rest are vocabulary lessons tracked as
-- whole units.
CREATE TABLE lessons (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    level TEXT NOT NULL,
    sort_order INTEGER NOT NULL
);


-- The 28 letters, with their four positional forms, audio filenames and
-- an example word. This drives the alphabet lesson pages.
CREATE TABLE letters (
    id INTEGER PRIMARY KEY,
    letter TEXT NOT NULL,
    name TEXT NOT NULL,
    sound TEXT NOT NULL,
    name_audio TEXT,
    sound_audio TEXT,
    isolated TEXT,
    beginning TEXT,
    middle TEXT,
    "end" TEXT,
    example TEXT,
    example_english TEXT
);


-- Study items belonging to a lesson: the 28 letters for lesson 1 and
-- the harakat examples for lesson 5. Also used as the quiz pool.
CREATE TABLE lesson_items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    lesson_id INTEGER NOT NULL,
    arabic TEXT NOT NULL,
    transliteration TEXT NOT NULL,
    english TEXT NOT NULL,
    item_type TEXT NOT NULL,
    sort_order INTEGER NOT NULL,
    audio TEXT,
    FOREIGN KEY (lesson_id) REFERENCES lessons(id)
);


-- Vocabulary words shown on the lesson pages and saved to favorites.
CREATE TABLE vocabulary (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    lesson_id INTEGER NOT NULL,
    arabic TEXT NOT NULL,
    transliteration TEXT NOT NULL,
    english TEXT NOT NULL,
    FOREIGN KEY (lesson_id) REFERENCES lessons(id)
);


-- Vocabulary a user has starred.
CREATE TABLE favorites (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    vocabulary_id INTEGER NOT NULL,
    UNIQUE(user_id, vocabulary_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (vocabulary_id) REFERENCES vocabulary(id)
);


-- One row per user per lesson. register() creates these up front with
-- completed = 0, so completing a lesson is an UPDATE, not an INSERT.
CREATE TABLE user_progress (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    lesson_id INTEGER NOT NULL,
    completed INTEGER NOT NULL DEFAULT 0,
    UNIQUE(user_id, lesson_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (lesson_id) REFERENCES lessons(id)
);


-- Per letter progress within the alphabet lesson.
CREATE TABLE letter_progress (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    letter_id INTEGER NOT NULL,
    completed INTEGER NOT NULL DEFAULT 0,
    UNIQUE(user_id, letter_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (letter_id) REFERENCES letters(id)
);


-- One row per completed quiz round. Questions are generated at random
-- from lesson_items and vocabulary, so only the score is stored.
CREATE TABLE quiz_results (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    score INTEGER NOT NULL,
    total INTEGER NOT NULL,
    completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
