import asyncio
import edge_tts
import os

examples = {
    "alif": "أسد",
    "baa": "باب",
    "taa": "تفاح",
    "thaa": "ثوب",
    "jeem": "جمل",
    "haa": "حصان",
    "khaa": "خبز",
    "daal": "دب",
    "thaal": "ذهب",
    "raa": "رجل",
    "zaay": "زهرة",
    "seen": "سمك",
    "sheen": "شمس",
    "saad": "صقر",
    "daad": "ضوء",
    "taa_emphatic": "طعام",
    "thaa_emphatic": "ظرف",
    "ayn": "عين",
    "ghayn": "غزال",
    "faa": "فم",
    "qaaf": "قلم",
    "kaaf": "كتاب",
    "laam": "لبن",
    "meem": "ماء",
    "noon": "نجم",
    "haa2": "هدية",
    "waaw": "ورد",
    "yaa": "يد"
}

voice = "ar-SA-HamedNeural"

async def main():
    folder = "static/audio/examples"
    os.makedirs(folder, exist_ok=True)

    for key, word in examples.items():
        await edge_tts.Communicate(
            word,
            voice
        ).save(f"{folder}/{key}.mp3")
        print("Done:", key)

asyncio.run(main())
