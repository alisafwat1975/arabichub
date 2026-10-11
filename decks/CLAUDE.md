# ArabicHub Arabic Course — standing instructions

These instructions apply to every chapter deck made in this folder.

## Where to work and what to deliver
- Work on this Mac. Apple Keynote is installed here.
- Save every final file to `/Users/mac/Desktop/Arabic Course_Cluade_Ouputs`.
- For each chapter, deliver:
  - the native, editable Keynote file (`.key`)
  - a preview PDF exported **from Keynote**
- Never deliver a PPTX as the final file. You may build a PPTX programmatically first, but then open it in Keynote, save it as `.key`, and export the PDF from Keynote (see `2.10-emphatic-tools/convert_to_keynote.sh`).
- Before saying a slide is checked, open the `.key` and look at every slide.

## Design reference
- Open the existing chapter decks in the output folder and copy their slide size, frame, chapter sidebar, typography, teacher footer ("Mrs Layla") and animation style. Known decks: Adverbs, Adjectives, Interrogative Tools, Negation, Emphatic Tools.
- The reusable build toolkit is in this repo: `2.10-emphatic-tools/deckkit.py` (RTL text, final-letter rule, builds) and `layouts.py` (frame, cards, tables, drills, "You Are Here" openers, road map).

## Language rules
- The audience is adult non-Arab learners. Every Arabic item has an English translation and, where useful, a transliteration.
- No vowel sign on the final letter of a word. A final shadda stays. Case endings go in the transliteration.
- Arabic punctuation (؟ ، ؛) inside Arabic text.
- RTL by default for Arabic. A slide title never begins with Arabic.
- Read everything from the right: cards, columns, steps. Arrows point left. Arabic wipes in from the right.
- Every drill has its answers, either revealed on the slide or on a separate answer slide.
- Check the grammar. Never label a noun as a particle or treat a prefix as a separate word.
