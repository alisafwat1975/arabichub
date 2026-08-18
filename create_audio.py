import asyncio
import edge_tts
import os

letters = {
    "alif": ("ألف", "ا"),
    "baa": ("باء", "بَ"),
    "taa": ("تاء", "تَ"),
    "thaa": ("ثاء", "ثَ"),
    "jeem": ("جيم", "جَ"),
    "haa": ("حاء", "حَ"),
    "khaa": ("خاء", "خَ"),
    "daal": ("دال", "دَ"),
    "thaal": ("ذال", "ذَ"),
    "raa": ("راء", "رَ"),
    "zaay": ("زاي", "زَ"),
    "seen": ("سين", "سَ"),
    "sheen": ("شين", "شَ"),
    "saad": ("صاد", "صَ"),
    "daad": ("ضاد", "ضَ"),
    "taa_emphatic": ("طاء", "طَ"),
    "thaa_emphatic": ("ظاء", "ظَ"),
    "ayn": ("عين", "عَ"),
    "ghayn": ("غين", "غَ"),
    "faa": ("فاء", "فَ"),
    "qaaf": ("قاف", "قَ"),
    "kaaf": ("كاف", "كَ"),
    "laam": ("لام", "لَ"),
    "meem": ("ميم", "مَ"),
    "noon": ("نون", "نَ"),
    "haa2": ("هاء", "هَ"),
    "waaw": ("واو", "وَ"),
    "yaa": ("ياء", "يَ")
}

voice = "ar-SA-HamedNeural"

async def main():
    folder = "static/audio/alphabet"

    for key, (name, sound) in letters.items():

        await edge_tts.Communicate(
            name,
            voice
        ).save(f"{folder}/{key}_name.mp3")

        await edge_tts.Communicate(
            sound,
            voice
        ).save(f"{folder}/{key}_sound.mp3")

        print("Done:", key)

asyncio.run(main())
