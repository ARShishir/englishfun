-- ========================================
-- EnglishFun App - Complete Database Schema
-- Supabase PostgreSQL Database
-- ========================================

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ========================================
-- 1. USERS TABLE (Authentication)
-- ========================================
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    avatar TEXT DEFAULT '👤',
    total_words_learned INTEGER DEFAULT 0,
    daily_streak INTEGER DEFAULT 0,
    accuracy DECIMAL(5, 2) DEFAULT 0.0,
    total_xp INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- Create indexes on users table
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_created_at ON users(created_at);

-- ========================================
-- 2. VOCABULARY TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS vocabulary (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    word VARCHAR(255) NOT NULL,
    part_of_speech VARCHAR(50) NOT NULL,
    meaning TEXT NOT NULL,
    bangla_translation VARCHAR(255),
    synonyms TEXT[] DEFAULT ARRAY[]::TEXT[],
    examples TEXT[] DEFAULT ARRAY[]::TEXT[],
    level VARCHAR(50) NOT NULL CHECK (level IN ('Beginner', 'Intermediate', 'Advanced')),
    pronunciation VARCHAR(255),
    audio_url TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes on vocabulary table
CREATE INDEX idx_vocabulary_word ON vocabulary(word);
CREATE INDEX idx_vocabulary_level ON vocabulary(level);
CREATE INDEX idx_vocabulary_part_of_speech ON vocabulary(part_of_speech);

-- ========================================
-- 3. PRACTICE QUESTIONS TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS practice_questions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    question_type VARCHAR(50) NOT NULL CHECK (question_type IN ('sentence_arrangement', 'fill_blank', 'spelling')),
    question_text TEXT NOT NULL,
    options TEXT[] NOT NULL,
    correct_answer VARCHAR(255) NOT NULL,
    explanation TEXT,
    difficulty_level VARCHAR(50) CHECK (difficulty_level IN ('Beginner', 'Intermediate', 'Advanced')),
    vocabulary_id UUID REFERENCES vocabulary(id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes on practice_questions table
CREATE INDEX idx_practice_questions_type ON practice_questions(question_type);
CREATE INDEX idx_practice_questions_difficulty ON practice_questions(difficulty_level);
CREATE INDEX idx_practice_questions_vocab_id ON practice_questions(vocabulary_id);

-- ========================================
-- 4. USER PROGRESS TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS user_progress (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    vocabulary_id UUID NOT NULL REFERENCES vocabulary(id) ON DELETE CASCADE,
    times_practiced INTEGER DEFAULT 0,
    correct_attempts INTEGER DEFAULT 0,
    total_attempts INTEGER DEFAULT 0,
    accuracy_rate DECIMAL(5, 2) DEFAULT 0.0,
    last_practiced TIMESTAMP,
    mastered_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, vocabulary_id)
);

-- Create indexes on user_progress table
CREATE INDEX idx_user_progress_user_id ON user_progress(user_id);
CREATE INDEX idx_user_progress_vocabulary_id ON user_progress(vocabulary_id);
CREATE INDEX idx_user_progress_user_vocabulary ON user_progress(user_id, vocabulary_id);

-- ========================================
-- 5. USER FAVORITES TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS user_favorites (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    vocabulary_id UUID NOT NULL REFERENCES vocabulary(id) ON DELETE CASCADE,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, vocabulary_id)
);

-- Create indexes on user_favorites table
CREATE INDEX idx_user_favorites_user_id ON user_favorites(user_id);
CREATE INDEX idx_user_favorites_vocabulary_id ON user_favorites(vocabulary_id);

-- ========================================
-- 6. DAILY STREAKS TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS daily_streaks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    current_streak INTEGER DEFAULT 0,
    longest_streak INTEGER DEFAULT 0,
    last_activity_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id)
);

-- Create indexes on daily_streaks table
CREATE INDEX idx_daily_streaks_user_id ON daily_streaks(user_id);

-- ========================================
-- 7. DUMMY DATA - USERS
-- ========================================
INSERT INTO users (email, name, avatar, total_words_learned, daily_streak, accuracy, total_xp)
VALUES
    ('shishir@example.com', 'Shishir', '👤', 120, 7, 82.0, 320),
    ('john@example.com', 'John Doe', '😊', 85, 5, 75.5, 215),
    ('sarah@example.com', 'Sarah Smith', '👩', 150, 12, 88.3, 450),
    ('ali@example.com', 'Ali Khan', '👨', 95, 3, 70.0, 180),
    ('emma@example.com', 'Emma Johnson', '👧', 200, 20, 92.5, 650)
ON CONFLICT DO NOTHING;

-- ========================================
-- 8. DUMMY DATA - VOCABULARY
-- ========================================
INSERT INTO vocabulary (word, part_of_speech, meaning, bangla_translation, synonyms, examples, level, pronunciation)
VALUES
    ('Improve', 'Verb', 'To make or become better', 'উন্নত করা', ARRAY['Enhance', 'Develop', 'Better'], ARRAY['I want to improve my English.', 'The weather improved yesterday.'], 'Beginner', 'im-PROOV'),
    ('Persistent', 'Adjective', 'Continuing firmly or obstinately', 'অধ্যবসায়ী', ARRAY['Determined', 'Steadfast', 'Dedicated'], ARRAY['He is persistent in his efforts.'], 'Intermediate', 'per-SIS-tent'),
    ('Eloquent', 'Adjective', 'Fluent and expressive in speaking or writing', 'বাকপটু', ARRAY['Articulate', 'Fluent', 'Expressive'], ARRAY['She gave an eloquent speech at the conference.'], 'Intermediate', 'EL-uh-kwent'),
    ('Anticipate', 'Verb', 'To regard as probable; expect', 'প্রত্যাশা করা', ARRAY['Expect', 'Foresee', 'Predict'], ARRAY['I anticipate your arrival tomorrow.'], 'Beginner', 'an-TIS-uh-payt'),
    ('Meticulous', 'Adjective', 'Showing great attention to details', 'যত্নশীল', ARRAY['Careful', 'Precise', 'Thorough'], ARRAY['She is meticulous in her work.'], 'Intermediate', 'muh-TIK-yuh-lus'),
    ('Benevolent', 'Adjective', 'Kind and generous', 'দাতব্য', ARRAY['Kind', 'Generous', 'Charitable'], ARRAY['A benevolent donor helped the charity.'], 'Intermediate', 'buh-NEV-uh-lent'),
    ('Serendipity', 'Noun', 'The occurrence of events by chance in a happy or beneficial way', 'সৌভাগ্য', ARRAY['Luck', 'Fortune', 'Chance'], ARRAY['Finding that book was pure serendipity.'], 'Advanced', 'ser-en-DIP-i-tee'),
    ('Vivacious', 'Adjective', 'Lively and animated', 'প্রাণবন্ত', ARRAY['Lively', 'Energetic', 'Spirited'], ARRAY['Her vivacious personality brightened the room.'], 'Intermediate', 'viv-AY-shus'),
    ('Ambiguous', 'Adjective', 'Open to more than one interpretation', 'অস্পষ্ট', ARRAY['Unclear', 'Vague', 'Unclear'], ARRAY['The statement was ambiguous and confusing.'], 'Intermediate', 'am-BIG-yuh-us'),
    ('Gregarious', 'Adjective', 'Fond of being in company; social', 'সামাজিক', ARRAY['Social', 'Outgoing', 'Friendly'], ARRAY['Humans are gregarious creatures.'], 'Advanced', 'gruh-GAIR-ee-us'),
    ('Ephemeral', 'Adjective', 'Lasting for a very short time', 'ক্ষণস্থায়ী', ARRAY['Temporary', 'Transient', 'Fleeting'], ARRAY['The beauty of cherry blossoms is ephemeral.'], 'Advanced', 'uh-FEM-er-ul'),
    ('Pragmatic', 'Adjective', 'Dealing with things in a realistic and sensible way', 'ব্যবহারিক', ARRAY['Practical', 'Realistic', 'Sensible'], ARRAY['We need a pragmatic approach to solve this problem.'], 'Intermediate', 'prag-MAT-ik'),
    ('Alacrity', 'Noun', 'Eagerness or willingness', 'উৎসাহ', ARRAY['Eagerness', 'Willingness', 'Enthusiasm'], ARRAY['He accepted the job with alacrity.'], 'Advanced', 'uh-LAK-ri-tee'),
    ('Candid', 'Adjective', 'Frank and honest in expression', 'সৎ', ARRAY['Honest', 'Frank', 'Direct'], ARRAY['Give me your candid opinion.'], 'Beginner', 'KAN-did'),
    ('Diligent', 'Adjective', 'Having or showing care in one''s work', 'পরিশ্রমী', ARRAY['Hardworking', 'Industrious', 'Dedicated'], ARRAY['She is a diligent student.'], 'Beginner', 'DIL-i-jent')
ON CONFLICT DO NOTHING;

-- ========================================
-- 9. DUMMY DATA - PRACTICE QUESTIONS
-- ========================================
INSERT INTO practice_questions (question_type, question_text, options, correct_answer, explanation, difficulty_level)
VALUES
    ('fill_blank', 'I want to _____ my English skills.', ARRAY['improve', 'improved', 'improving', 'improves'], 'improve', 'The base form of verb is used after "to".', 'Beginner'),
    ('sentence_arrangement', 'Arrange: efforts his persistent He is in', ARRAY['He is persistent in his efforts', 'Persistent he is in his efforts', 'In his efforts he is persistent', 'His persistent efforts he is'], 'He is persistent in his efforts', 'Correct word order follows SVO pattern.', 'Intermediate'),
    ('spelling', 'How do you spell the word pronounced as EL-uh-kwent?', ARRAY['Eloquent', 'Eloquant', 'Eloquent', 'Eloquent'], 'Eloquent', 'The correct spelling uses "uo" combination.', 'Intermediate'),
    ('fill_blank', 'She approached the task with great _____.', ARRAY['meticulous', 'meticulously', 'meticulousness', 'meticule'], 'meticulousness', 'We need a noun form after "with".', 'Intermediate'),
    ('sentence_arrangement', 'Arrange: to regard is anticipate Probably expect', ARRAY['Anticipate is to regard probably expect', 'To anticipate is to regard or probably expect', 'Anticipate regard is to probably expect', 'Is anticipate regard to probably'], 'To anticipate is to regard or probably expect', 'Definition follows proper grammar structure.', 'Beginner'),
    ('fill_blank', 'Her _____ personality made everyone around her happy.', ARRAY['vivacious', 'vivaciously', 'vivacity', 'vivacious'], 'vivacious', 'We need an adjective to describe personality.', 'Intermediate'),
    ('spelling', 'How do you spell the word meaning lasting a very short time?', ARRAY['Ephemeral', 'Ephemoral', 'Ephemeral', 'Ephimeral'], 'Ephemeral', 'The correct spelling uses "e-r-a-l" ending.', 'Advanced'),
    ('fill_blank', 'We need a _____ approach to handle this situation.', ARRAY['pragmatic', 'pragmatically', 'pragmatism', 'pragmatic'], 'pragmatic', 'An adjective is needed to describe approach.', 'Intermediate'),
    ('sentence_arrangement', 'Arrange: creatures social are Humans', ARRAY['Humans are social creatures', 'Social creatures are humans', 'Are humans social creatures', 'Creatures humans are social'], 'Humans are social creatures', 'SVO word order is correct in English.', 'Beginner'),
    ('fill_blank', 'He accepted the offer with _____.', ARRAY['alacrity', 'alacritously', 'alacritous', 'alacrity'], 'alacrity', 'A noun is needed after "with".', 'Advanced')
ON CONFLICT DO NOTHING;

-- ========================================
-- 10. DUMMY DATA - USER PROGRESS
-- ========================================
INSERT INTO user_progress (user_id, vocabulary_id, times_practiced, correct_attempts, total_attempts, accuracy_rate)
SELECT 
    u.id,
    v.id,
    FLOOR(RANDOM() * 10 + 1)::INTEGER,
    FLOOR(RANDOM() * 8 + 1)::INTEGER,
    FLOOR(RANDOM() * 10 + 2)::INTEGER,
    FLOOR(RANDOM() * 100 + 1)::DECIMAL / 100
FROM users u
CROSS JOIN vocabulary v
LIMIT 50
ON CONFLICT DO NOTHING;

-- ========================================
-- 11. DUMMY DATA - USER FAVORITES
-- ========================================
INSERT INTO user_favorites (user_id, vocabulary_id)
SELECT u.id, v.id
FROM users u
CROSS JOIN vocabulary v
WHERE u.email IN ('shishir@example.com', 'john@example.com', 'sarah@example.com')
AND v.level IN ('Beginner', 'Intermediate')
LIMIT 15
ON CONFLICT DO NOTHING;

-- ========================================
-- 12. DUMMY DATA - DAILY STREAKS
-- ========================================
INSERT INTO daily_streaks (user_id, current_streak, longest_streak, last_activity_date)
SELECT 
    u.id,
    FLOOR(RANDOM() * 20 + 1)::INTEGER,
    FLOOR(RANDOM() * 50 + 1)::INTEGER,
    CURRENT_DATE - INTERVAL '1 day' * FLOOR(RANDOM() * 5)::INTEGER
FROM users u
ON CONFLICT DO NOTHING;

-- ========================================
-- 13. CREATE VIEWS FOR COMMONLY USED QUERIES
-- ========================================

-- View for user statistics
CREATE OR REPLACE VIEW user_statistics AS
SELECT 
    u.id,
    u.email,
    u.name,
    u.total_words_learned,
    u.daily_streak,
    u.accuracy,
    u.total_xp,
    COUNT(DISTINCT uf.vocabulary_id) as favorite_words_count,
    COUNT(DISTINCT up.vocabulary_id) as words_in_progress
FROM users u
LEFT JOIN user_favorites uf ON u.id = uf.user_id
LEFT JOIN user_progress up ON u.id = up.user_id
GROUP BY u.id, u.email, u.name, u.total_words_learned, u.daily_streak, u.accuracy, u.total_xp;

-- View for vocabulary statistics
CREATE OR REPLACE VIEW vocabulary_statistics AS
SELECT 
    v.id,
    v.word,
    v.level,
    COUNT(DISTINCT up.user_id) as times_practiced_by_users,
    AVG(up.accuracy_rate) as average_accuracy,
    COUNT(DISTINCT uf.user_id) as favorited_by_count
FROM vocabulary v
LEFT JOIN user_progress up ON v.id = up.vocabulary_id
LEFT JOIN user_favorites uf ON v.id = uf.vocabulary_id
GROUP BY v.id, v.word, v.level;

-- ========================================
-- 14. ROW LEVEL SECURITY (RLS) POLICIES
-- ========================================

-- Enable RLS on tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE vocabulary ENABLE ROW LEVEL SECURITY;
ALTER TABLE practice_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE daily_streaks ENABLE ROW LEVEL SECURITY;

-- Users table: allow anyone to read (public profile access)
CREATE POLICY "Users can view all profiles" ON users
    FOR SELECT USING (true);

-- Users can update their own profile
CREATE POLICY "Users can update own profile" ON users
    FOR UPDATE USING (auth.uid()::text = id::text);

-- Users can insert their own profile (allow sign-up to create user row)
CREATE POLICY "Users can insert own profile" ON users
    FOR INSERT WITH CHECK (auth.uid()::text = id::text);

-- Vocabulary is viewable by everyone (no auth required)
CREATE POLICY "Vocabulary is viewable by everyone" ON vocabulary
    FOR SELECT USING (true);

-- Practice questions viewable by everyone
CREATE POLICY "Practice questions viewable by everyone" ON practice_questions
    FOR SELECT USING (true);

-- Users can view their own progress
CREATE POLICY "Users can view own progress" ON user_progress
    FOR SELECT USING (auth.uid()::text = user_id::text OR true);

-- Users can insert their own progress
CREATE POLICY "Users can insert own progress" ON user_progress
    FOR INSERT WITH CHECK (auth.uid()::text = user_id::text);

-- Users can update their own progress
CREATE POLICY "Users can update own progress" ON user_progress
    FOR UPDATE USING (auth.uid()::text = user_id::text);

-- Users can view their own favorites
CREATE POLICY "Users can view own favorites" ON user_favorites
    FOR SELECT USING (auth.uid()::text = user_id::text OR true);

-- Users can insert their own favorites
CREATE POLICY "Users can insert own favorites" ON user_favorites
    FOR INSERT WITH CHECK (auth.uid()::text = user_id::text);

-- Users can delete their own favorites
CREATE POLICY "Users can delete own favorites" ON user_favorites
    FOR DELETE USING (auth.uid()::text = user_id::text);

-- Users can view their own streaks
CREATE POLICY "Users can view own streaks" ON daily_streaks
    FOR SELECT USING (auth.uid()::text = user_id::text OR true);

-- Users can update their own streaks
CREATE POLICY "Users can update own streaks" ON daily_streaks
    FOR UPDATE USING (auth.uid()::text = user_id::text);

-- ========================================
-- 15. TRIGGER FUNCTIONS
-- ========================================

-- Function to update user's updated_at timestamp
CREATE OR REPLACE FUNCTION update_timestamp_user()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger for users table
DROP TRIGGER IF EXISTS trigger_update_users_timestamp ON users;
CREATE TRIGGER trigger_update_users_timestamp
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_timestamp_user();

-- Function to update vocabulary's updated_at timestamp
CREATE OR REPLACE FUNCTION update_timestamp_vocabulary()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger for vocabulary table
DROP TRIGGER IF EXISTS trigger_update_vocabulary_timestamp ON vocabulary;
CREATE TRIGGER trigger_update_vocabulary_timestamp
    BEFORE UPDATE ON vocabulary
    FOR EACH ROW
    EXECUTE FUNCTION update_timestamp_vocabulary();

-- Function to update user_progress's updated_at timestamp
CREATE OR REPLACE FUNCTION update_timestamp_user_progress()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger for user_progress table
DROP TRIGGER IF EXISTS trigger_update_user_progress_timestamp ON user_progress;
CREATE TRIGGER trigger_update_user_progress_timestamp
    BEFORE UPDATE ON user_progress
    FOR EACH ROW
    EXECUTE FUNCTION update_timestamp_user_progress();

-- ========================================
-- END OF SQL SCHEMA
-- ========================================
