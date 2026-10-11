# Chapter 2.10 — Emphatic Tools (أَدَوَات التَّوْكِيد)

The teaching deck for ArabicHub Chapter 2.10. It has 80 slides, 960 × 540 pt (16:9), and is taught by Mrs Layla.

## Files

| File | What it is |
|---|---|
| `build_ch2_10.py` | All slide content and layout. This is the source of truth. |
| `layouts.py` | Course frame (chapter sidebar, title box, footer), cards, tables, drills, openers |
| `deckkit.py` | RTL text engine, final-letter rule, build animations (wipe from the right, fade) |
| `qa_check.py` | Automated checks on the built file |
| `convert_to_keynote.sh` | **Run on a Mac.** Opens the build in Keynote, saves the native `.key` and exports the Keynote PDF |
| `out/Chapter-2.10-Emphatic-Tools.pptx` | The programmatic build (an intermediate file, not the final format) |
| `out/Chapter-2.10-Emphatic-Tools-PREVIEW-LibreOffice.pdf` | A preview rendered on Linux with substitute fonts. **This is not the Keynote export.** |

## Status

- The content, layout and build animations are complete. All 80 slides were checked visually in the LibreOffice render.
- **The native `.key` file and the Keynote-exported PDF have not been produced yet.** Keynote runs only on macOS. To make them, run `./convert_to_keynote.sh` on a Mac, then check the result in Keynote. Pay particular attention to the font metrics of Geeza Pro and Chalkboard SE and to how the animations were imported.

## Rebuild

```bash
pip install python-pptx
python3 build_ch2_10.py      # writes out/Chapter-2.10-Emphatic-Tools.pptx
python3 qa_check.py          # final-letter rule, RTL punctuation, titles, slide ranges
./convert_to_keynote.sh      # macOS + Keynote: .key + Keynote PDF
```

Every "Stop n of 6 · slides x–y" range and every road-map range is calculated at build time from the final slide order. Adding or removing slides updates them automatically.

## Teaching inventory (after a grammar check)

| # | Tool | Category | Notes |
|---|---|---|---|
| 1 | إِنّ inna | particle (sister of inna) | Subject becomes accusative; predicate stays nominative |
| 2 | أَنّ anna | particle (sister of inna) | "that"; light emphasis; position decides between إِنّ and أَنّ |
| 3 | قَد qad | verbal particle | Past verb: completion. Present verb: possibility |
| 4 | لَقَد laqad | لَـ + قَد | Past verbs only |
| 5 | لَـ la- | attached prefix | lām al-ibtidāʾ / al-lām al-muzaḥlaqa; not لِـ |
| 6 | إِنَّمَا innamā | إِنّ + restraining mā | Restriction, not plain emphasis; cancels the case effect |
| 7 | نَفْس nafs | noun | After a noun + suffix it is tawkīd. Before a noun it means "the same" (iḍāfa) |
| 8 | عَيْن ʿayn | noun | Formal; "the very same" |
| 9 | كُلّ kull | noun | Only the after-noun + suffix use is tawkīd; before a noun it is a quantifier |
| 10 | جَمِيع jamīʿ | noun | Never "every"; جَمِيعًا means "all together" |

Corrections to the proposed list:

- Tools 3 and 4 are taught in the order قَد then لَقَد, because لَقَد is built from قَد.
- نَفْس, عَيْن, كُلّ and جَمِيع are taught as nouns. They are not particles.
- The deck contrasts these look-alikes: إِنْ "if", أَنْ "to", إِنّ مَا "indeed what", and لِـ "for".
- The emphatic nūn (لَأُسَاعِدَنَّك) is mentioned as "you may also meet" and is not given a tool number.

## Conventions applied automatically

- **Final-letter rule.** Vowel signs on a word's final letter are stripped at build time. A final shadda is kept (كُلّ, إِنّ). Case endings appear in the transliteration.
- **Direction.** Every Arabic-led paragraph is RTL and starts with U+200F. English-led lines are LTR and start with U+200E when they contain Arabic.
- **Punctuation.** Latin `? , ;` inside an RTL paragraph is converted to `؟ ، ؛`.
- **Reading order.** Cards, table columns, drill rows and road-map stops are all laid out from the right. Arrows point left.
- **Builds.** Arabic boxes wipe in from the right. Table cells appear one by one, right to left, with one click per row. Drills reveal the prompt, then the cue, then the answer.

## Assumptions to confirm

- The earlier chapter decks (2.6–2.8) were not available, so the frame follows the chapter-list reference image and the written spec. The sidebar shows the chapter group 2.10–2.12 and highlights 2.10.
- Fonts are Chalkboard SE for English and Geeza Pro for Arabic. Both ship with macOS.
- The title boxes use a `#F2F2F2` fill, a `#A7A7A7` rounded border and wine title text. Wine text on a solid `#A7A7A7` fill would be hard to read.
