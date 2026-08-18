-- =====================================================
-- ArabicHub
-- Seed Data
--
-- Load after schema.sql:
--     sqlite3 arabic.db < schema.sql
--     sqlite3 arabic.db < seed.sql
--
-- Contains all lesson content: 5 lessons, the 28 letters with their
-- positional forms and audio, 67 lesson items (alphabet + harakat) and
-- 42 vocabulary words. User data is created by the app at runtime.
-- =====================================================


--------------------------------------------------------
-- LESSONS
--------------------------------------------------------
INSERT INTO lessons
(title, description, level, sort_order)
VALUES
('Arabic Alphabet', 'Learn the 28 Arabic letters and their pronunciation.', 'Beginner', 1),
('Greetings', 'Learn everyday Arabic greetings.', 'Beginner', 2),
('Numbers', 'Learn Arabic numbers from 1 to 10.', 'Beginner', 3),
('Basic Sentences', 'Learn useful everyday sentences.', 'Beginner', 4),
('Harakat', 'Learn Arabic vowels and pronunciation marks.', 'Beginner', 5);


--------------------------------------------------------
-- LETTERS (drives the alphabet lesson pages)
--------------------------------------------------------
INSERT INTO letters
(id, letter, name, sound, name_audio, sound_audio, isolated, beginning, middle, "end", example, example_english)
VALUES
(1, 'ا', 'Alif', 'a', 'alif_name.mp3', 'alif_sound.mp3', 'ا', 'ا', 'ـاـ', 'ـا', 'أسد', 'Lion'),
(2, 'ب', 'Ba', 'b', 'baa_name.mp3', 'baa_sound.mp3', 'ب', 'بـ', 'ـبـ', 'ـب', 'باب', 'Door'),
(3, 'ت', 'Ta', 't', 'taa_name.mp3', 'taa_sound.mp3', 'ت', 'تـ', 'ـتـ', 'ـت', 'تفاح', 'Apple'),
(4, 'ث', 'Tha', 'th', 'thaa_name.mp3', 'thaa_sound.mp3', 'ث', 'ثـ', 'ـثـ', 'ـث', 'ثوب', 'Garment'),
(5, 'ج', 'Jeem', 'j', 'jeem_name.mp3', 'jeem_sound.mp3', 'ج', 'جـ', 'ـجـ', 'ـج', 'جمل', 'Camel'),
(6, 'ح', 'Ha', 'h', 'haa_name.mp3', 'haa_sound.mp3', 'ح', 'حـ', 'ـحـ', 'ـح', 'حصان', 'Horse'),
(7, 'خ', 'Kha', 'kh', 'khaa_name.mp3', 'khaa_sound.mp3', 'خ', 'خـ', 'ـخـ', 'ـخ', 'خبز', 'Bread'),
(8, 'د', 'Dal', 'd', 'daal_name.mp3', 'daal_sound.mp3', 'د', 'د', 'ـد', 'ـد', 'دب', 'Bear'),
(9, 'ذ', 'Dhal', 'dh', 'thaal_name.mp3', 'thaal_sound.mp3', 'ذ', 'ذ', 'ـذ', 'ـذ', 'ذهب', 'Gold'),
(10, 'ر', 'Ra', 'r', 'raa_name.mp3', 'raa_sound.mp3', 'ر', 'ر', 'ـر', 'ـر', 'رجل', 'Man'),
(11, 'ز', 'Zay', 'z', 'zaay_name.mp3', 'zaay_sound.mp3', 'ز', 'ز', 'ـز', 'ـز', 'زهرة', 'Flower'),
(12, 'س', 'Seen', 's', 'seen_name.mp3', 'seen_sound.mp3', 'س', 'سـ', 'ـسـ', 'ـس', 'سمك', 'Fish'),
(13, 'ش', 'Sheen', 'sh', 'sheen_name.mp3', 'sheen_sound.mp3', 'ش', 'شـ', 'ـشـ', 'ـش', 'شمس', 'Sun'),
(14, 'ص', 'Sad', 's', 'saad_name.mp3', 'saad_sound.mp3', 'ص', 'صـ', 'ـصـ', 'ـص', 'صقر', 'Falcon'),
(15, 'ض', 'Dad', 'd', 'daad_name.mp3', 'daad_sound.mp3', 'ض', 'ضـ', 'ـضـ', 'ـض', 'ضوء', 'Light'),
(16, 'ط', 'Ta emphatic', 't', 'taa_emphatic_name.mp3', 'taa_emphatic_sound.mp3', 'ط', 'طـ', 'ـطـ', 'ـط', 'طعام', 'Food'),
(17, 'ظ', 'Dha', 'dh', 'thaa_emphatic_name.mp3', 'thaa_emphatic_sound.mp3', 'ظ', 'ظـ', 'ـظـ', 'ـظ', 'ظرف', 'Envelope'),
(18, 'ع', 'Ayn', 'ʿ', 'ayn_name.mp3', 'ayn_sound.mp3', 'ع', 'عـ', 'ـعـ', 'ـع', 'عين', 'Eye'),
(19, 'غ', 'Ghayn', 'gh', 'ghayn_name.mp3', 'ghayn_sound.mp3', 'غ', 'غـ', 'ـغـ', 'ـغ', 'غزال', 'Gazelle'),
(20, 'ف', 'Fa', 'f', 'faa_name.mp3', 'faa_sound.mp3', 'ف', 'فـ', 'ـفـ', 'ـف', 'فم', 'Mouth'),
(21, 'ق', 'Qaf', 'q', 'qaaf_name.mp3', 'qaaf_sound.mp3', 'ق', 'قـ', 'ـقـ', 'ـق', 'قلم', 'Pen'),
(22, 'ك', 'Kaf', 'k', 'kaaf_name.mp3', 'kaaf_sound.mp3', 'ك', 'كـ', 'ـكـ', 'ـك', 'كتاب', 'Book'),
(23, 'ل', 'Lam', 'l', 'laam_name.mp3', 'laam_sound.mp3', 'ل', 'لـ', 'ـلـ', 'ـل', 'لبن', 'Milk'),
(24, 'م', 'Meem', 'm', 'meem_name.mp3', 'meem_sound.mp3', 'م', 'مـ', 'ـمـ', 'ـم', 'ماء', 'Water'),
(25, 'ن', 'Noon', 'n', 'noon_name.mp3', 'noon_sound.mp3', 'ن', 'نـ', 'ـنـ', 'ـن', 'نجم', 'Star'),
(26, 'ه', 'Ha', 'h', 'haa_name.mp3', 'haa_sound.mp3', 'ه', 'هـ', 'ـهـ', 'ـه', 'هدية', 'Gift'),
(27, 'و', 'Waw', 'w', 'waaw_name.mp3', 'waaw_sound.mp3', 'و', 'و', 'ـو', 'ـو', 'ورد', 'Rose'),
(28, 'ي', 'Ya', 'y', 'yaa_name.mp3', 'yaa_sound.mp3', 'ي', 'يـ', 'ـيـ', 'ـي', 'يد', 'Hand');


--------------------------------------------------------
-- LESSON ITEMS (alphabet + harakat, also the quiz pool)
--------------------------------------------------------
INSERT INTO lesson_items
(lesson_id, arabic, transliteration, english, item_type, sort_order)
VALUES
(1, 'ا', 'Alif', 'Alif', 'letter', 1),
(1, 'ب', 'Ba', 'B', 'letter', 2),
(1, 'ت', 'Ta', 'T', 'letter', 3),
(1, 'ث', 'Tha', 'TH', 'letter', 4),
(1, 'ج', 'Jim', 'J', 'letter', 5),
(1, 'ح', 'Ha', 'Deep H', 'letter', 6),
(1, 'خ', 'Kha', 'KH', 'letter', 7),
(1, 'د', 'Dal', 'D', 'letter', 8),
(1, 'ذ', 'Dhal', 'DH', 'letter', 9),
(1, 'ر', 'Ra', 'R', 'letter', 10),
(1, 'ز', 'Zay', 'Z', 'letter', 11),
(1, 'س', 'Sin', 'S', 'letter', 12),
(1, 'ش', 'Shin', 'SH', 'letter', 13),
(1, 'ص', 'Sad', 'Emphatic S', 'letter', 14),
(1, 'ض', 'Dad', 'Emphatic D', 'letter', 15),
(1, 'ط', 'Ta', 'Emphatic T', 'letter', 16),
(1, 'ظ', 'Za', 'Emphatic Z', 'letter', 17),
(1, 'ع', 'Ayn', 'Ayn', 'letter', 18),
(1, 'غ', 'Ghayn', 'GH', 'letter', 19),
(1, 'ف', 'Fa', 'F', 'letter', 20),
(1, 'ق', 'Qaf', 'Q', 'letter', 21),
(1, 'ك', 'Kaf', 'K', 'letter', 22),
(1, 'ل', 'Lam', 'L', 'letter', 23),
(1, 'م', 'Mim', 'M', 'letter', 24),
(1, 'ن', 'Nun', 'N', 'letter', 25),
(1, 'هـ', 'Ha', 'H', 'letter', 26),
(1, 'و', 'Waw', 'W / Long U', 'letter', 27),
(1, 'ي', 'Ya', 'Y / Long I', 'letter', 28),
(2, 'مرحبا', 'Marhaban', 'Hello', 'word', 1),
(2, 'السلام عليكم', 'As-salamu alaykum', 'Peace be upon you', 'phrase', 2),
(2, 'صباح الخير', 'Sabah al-khayr', 'Good morning', 'phrase', 3),
(2, 'مساء الخير', 'Masa al-khayr', 'Good evening', 'phrase', 4),
(2, 'شكرا', 'Shukran', 'Thank you', 'word', 5),
(3, 'واحد', 'Wahid', 'One', 'number', 1),
(3, 'اثنان', 'Ithnan', 'Two', 'number', 2),
(3, 'ثلاثة', 'Thalatha', 'Three', 'number', 3),
(3, 'أربعة', 'Arba’a', 'Four', 'number', 4),
(3, 'خمسة', 'Khamsa', 'Five', 'number', 5),
(4, 'أنا طالب', 'Ana talib', 'I am a student', 'sentence', 1),
(4, 'أنا أتعلم العربية', 'Ana ataallam al-arabiya', 'I am learning Arabic', 'sentence', 2),
(4, 'أين الحمام؟', 'Ayna al-hammam?', 'Where is the bathroom?', 'sentence', 3),
(4, 'كم السعر؟', 'Kam al-si’r?', 'How much is the price?', 'sentence', 4),
(4, 'أريد ماء', 'Ureed maa', 'I want water', 'sentence', 5),
(5, 'بَ', 'ba', 'Fatha (a)', 'harakat', 1),
(5, 'تَ', 'ta', 'Fatha (a)', 'harakat', 2),
(5, 'مَ', 'ma', 'Fatha (a)', 'harakat', 3),
(5, 'بِ', 'bi', 'Kasra (i)', 'harakat', 4),
(5, 'تِ', 'ti', 'Kasra (i)', 'harakat', 5),
(5, 'مِ', 'mi', 'Kasra (i)', 'harakat', 6),
(5, 'بُ', 'bu', 'Damma (u)', 'harakat', 7),
(5, 'تُ', 'tu', 'Damma (u)', 'harakat', 8),
(5, 'مُ', 'mu', 'Damma (u)', 'harakat', 9),
(5, 'بْ', 'b', 'Sukun (no vowel)', 'harakat', 10),
(5, 'تْ', 't', 'Sukun (no vowel)', 'harakat', 11),
(5, 'مْ', 'm', 'Sukun (no vowel)', 'harakat', 12),
(5, 'بّ', 'bb', 'Shadda (double consonant)', 'harakat', 13),
(5, 'تّ', 'tt', 'Shadda (double consonant)', 'harakat', 14),
(5, 'مّ', 'mm', 'Shadda (double consonant)', 'harakat', 15),
(5, 'بً', 'ban', 'Tanween Fath (an)', 'harakat', 16),
(5, 'تً', 'tan', 'Tanween Fath (an)', 'harakat', 17),
(5, 'مً', 'man', 'Tanween Fath (an)', 'harakat', 18),
(5, 'بٍ', 'bin', 'Tanween Kasr (in)', 'harakat', 19),
(5, 'تٍ', 'tin', 'Tanween Kasr (in)', 'harakat', 20),
(5, 'مٍ', 'min', 'Tanween Kasr (in)', 'harakat', 21),
(5, 'بٌ', 'bun', 'Tanween Damm (un)', 'harakat', 22),
(5, 'تٌ', 'tun', 'Tanween Damm (un)', 'harakat', 23),
(5, 'مٌ', 'mun', 'Tanween Damm (un)', 'harakat', 24);


--------------------------------------------------------
-- VOCABULARY
--------------------------------------------------------
INSERT INTO vocabulary
(lesson_id, arabic, transliteration, english)
VALUES
(2, 'مرحبا', 'Marhaban', 'Hello'),
(2, 'السلام عليكم', 'As-salamu alaykum', 'Peace be upon you'),
(2, 'وعليكم السلام', 'Wa alaykum as-salam', 'And upon you be peace'),
(2, 'صباح الخير', 'Sabah al-khayr', 'Good morning'),
(2, 'مساء الخير', 'Masa al-khayr', 'Good evening'),
(2, 'كيف حالك؟', 'Kayfa haluk?', 'How are you?'),
(2, 'بخير', 'Bikhayr', 'I am fine'),
(2, 'شكرا', 'Shukran', 'Thank you'),
(2, 'عفوا', 'Afwan', 'You are welcome'),
(2, 'إلى اللقاء', 'Ila al-liqa', 'Goodbye'),
(3, '٠', 'Sifr', 'Zero'),
(3, '١', 'Wahid', 'One'),
(3, '٢', 'Ithnan', 'Two'),
(3, '٣', 'Thalatha', 'Three'),
(3, '٤', 'Arba‘a', 'Four'),
(3, '٥', 'Khamsa', 'Five'),
(3, '٦', 'Sitta', 'Six'),
(3, '٧', 'Sab‘a', 'Seven'),
(3, '٨', 'Thamaniya', 'Eight'),
(3, '٩', 'Tis‘a', 'Nine'),
(3, '١٠', 'Ashara', 'Ten'),
(4, 'ما اسمك؟', 'Ma ismuk?', 'What is your name?'),
(4, 'اسمي', 'Ismi', 'My name is'),
(4, 'من فضلك', 'Min fadlik', 'Please'),
(4, 'نعم', 'Na''am', 'Yes'),
(4, 'لا', 'La', 'No'),
(4, 'لا أفهم', 'La afham', 'I do not understand'),
(4, 'أفهم', 'Afham', 'I understand'),
(4, 'أين الحمام؟', 'Ayna al-hammam?', 'Where is the bathroom?'),
(4, 'أريد ماء', 'Ureed maa', 'I want water'),
(4, 'كم هذا؟', 'Kam hadha?', 'How much is this?'),
(5, 'َ', 'Fatha', 'Short vowel a'),
(5, 'ِ', 'Kasra', 'Short vowel i'),
(5, 'ُ', 'Damma', 'Short vowel u'),
(5, 'ً', 'Fathatan', 'Double a sound'),
(5, 'ٍ', 'Kasratan', 'Double i sound'),
(5, 'ٌ', 'Dammatan', 'Double u sound'),
(5, 'ْ', 'Sukun', 'No vowel'),
(5, 'ّ', 'Shadda', 'Double consonant'),
(5, 'ا', 'Alif', 'Long a sound'),
(5, 'و', 'Waw', 'Long u sound'),
(5, 'ي', 'Ya', 'Long i sound');
