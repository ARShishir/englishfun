# EnglishFun - Database Integration with Supabase

## Project Overview
This document describes the complete database schema and Supabase integration for the EnglishFun Flutter application.

## Database Setup Instructions

### 1. Supabase Configuration
Your Supabase credentials:
- **Project URL:** https://llmdumbnmsxfnvdgxchn.supabase.co
- **Publishable Key:** sb_publishable_eI1xXiAWxyPJ_G80QKy7NQ_Z-WFgEpa
- **Direct Connection String:** postgresql://postgres:[YOUR-PASSWORD]@db.llmdumbnmsxfnvdgxchn.supabase.co:5432/postgres

### 2. Execute SQL Schema
1. Go to Supabase Dashboard → SQL Editor
2. Click "New Query"
3. Copy the entire content from `sqleditor.sql`
4. Paste it into the SQL editor
5. Click "Run"

This will create:
- All required tables (users, vocabulary, practice_questions, etc.)
- Indexes for performance optimization
- Row Level Security (RLS) policies
- Trigger functions for automatic timestamp updates
- Dummy data for testing

### 3. Database Schema

#### Users Table
- **id**: UUID (Primary Key)
- **email**: Unique email address
- **name**: User's full name
- **avatar**: User avatar emoji
- **total_words_learned**: Number of words mastered
- **daily_streak**: Current learning streak
- **accuracy**: Average accuracy percentage
- **total_xp**: Total experience points
- **created_at**, **updated_at**: Timestamps
- **last_login**: Last login timestamp
- **is_active**: Account status

#### Vocabulary Table
- **id**: UUID (Primary Key)
- **word**: The vocabulary word
- **part_of_speech**: Noun, Verb, Adjective, etc.
- **meaning**: English meaning
- **bangla_translation**: Bengali translation
- **synonyms**: Array of synonyms
- **examples**: Array of usage examples
- **level**: Beginner, Intermediate, Advanced
- **pronunciation**: Pronunciation guide
- **audio_url**: Optional audio file URL
- **created_at**, **updated_at**: Timestamps

#### Practice Questions Table
- **id**: UUID (Primary Key)
- **question_type**: sentence_arrangement, fill_blank, spelling
- **question_text**: The practice question
- **options**: Array of multiple choice options
- **correct_answer**: Correct answer
- **explanation**: Explanation for the answer
- **difficulty_level**: Beginner, Intermediate, Advanced
- **vocabulary_id**: Foreign key to vocabulary
- **created_at**, **updated_at**: Timestamps

#### User Progress Table
- **id**: UUID (Primary Key)
- **user_id**: Foreign key to users
- **vocabulary_id**: Foreign key to vocabulary
- **times_practiced**: Number of times practiced
- **correct_attempts**: Correct answers count
- **total_attempts**: Total attempts count
- **accuracy_rate**: Accuracy percentage
- **last_practiced**: Last practice timestamp
- **mastered_at**: When word was mastered
- **created_at**, **updated_at**: Timestamps

#### User Favorites Table
- **id**: UUID (Primary Key)
- **user_id**: Foreign key to users
- **vocabulary_id**: Foreign key to vocabulary
- **added_at**: When added to favorites
- **Unique constraint** on (user_id, vocabulary_id)

#### Daily Streaks Table
- **id**: UUID (Primary Key)
- **user_id**: Foreign key to users
- **current_streak**: Current streak count
- **longest_streak**: Longest streak achieved
- **last_activity_date**: Last activity date
- **created_at**, **updated_at**: Timestamps

## Frontend Integration

### Files Added/Modified

#### New Files Created:
1. **lib/services/supabase_service.dart**
   - Core Supabase service for all database operations
   - Authentication methods (signup, signin, signout)
   - CRUD operations for all tables
   - Query helpers and converters

2. **lib/services/auth_provider.dart**
   - Riverpod providers for state management
   - Authentication state providers
   - User profile provider
   - Vocabulary and practice data providers
   - User progress and favorites providers

3. **lib/features/auth/signup_screen.dart**
   - New signup screen with form validation
   - Password confirmation matching
   - Minimum password length validation
   - Supabase signup integration

#### Modified Files:
1. **pubspec.yaml**
   - Added `supabase_flutter: ^2.6.0`
   - Added `postgres: ^3.1.0`

2. **lib/main.dart**
   - Initialize Supabase before app starts
   - Added WidgetsFlutterBinding.ensureInitialized()

3. **lib/app.dart**
   - Wrapped app with ProviderScope for Riverpod
   - Imported flutter_riverpod

4. **lib/features/auth/login_screen.dart**
   - Updated to ConsumerStatefulWidget
   - Integrated Supabase authentication
   - Email validation
   - Error handling with SnackBar
   - Navigate to signup from login

5. **lib/navigation/app_router.dart**
   - Added signup route
   - Imported SignupScreen

## Usage Examples

### Login Example
```dart
final authNotifier = ref.read(authControllerProvider.notifier);
await authNotifier.signIn(
  email: 'user@example.com',
  password: 'password123',
);
```

### Get Current User
```dart
final currentUser = ref.watch(currentUserProvider);
final userProfile = ref.watch(userProfileProvider);
```

### Get Vocabulary
```dart
final vocabulary = ref.watch(vocabularyProvider('Beginner'));
```

### Search Vocabulary
```dart
final searchResults = ref.watch(searchVocabularyProvider('improve'));
```

### Update User Progress
```dart
final supabase = SupabaseService();
await supabase.updateUserProgress(
  userId: userId,
  vocabularyId: vocabId,
  correctAttempts: 8,
  totalAttempts: 10,
  accuracyRate: 80.0,
);
```

### Add to Favorites
```dart
final supabase = SupabaseService();
await supabase.addToFavorites(
  userId: userId,
  vocabularyId: vocabularyId,
);
```

## Dummy Data Included
The SQL script includes dummy data for testing:
- **5 User accounts** with various learning progress
- **15 Vocabulary words** (Beginner to Advanced levels)
- **10 Practice questions** covering all question types
- **User progress records** for practice tracking
- **Favorites data** for testing favorite words feature
- **Daily streak data** for streak tracking

### Test Credentials
You can use any of these accounts to test:
- Email: shishir@example.com (120 words learned, 7-day streak)
- Email: john@example.com (85 words learned, 5-day streak)
- Email: sarah@example.com (150 words learned, 12-day streak)

Note: Since these are dummy accounts, you'll need to create new accounts through the signup screen for actual testing after running the SQL script. The dummy accounts are for testing the database structure and data relationships.

## Security Features
- Row Level Security (RLS) enabled on all tables
- Users can only see/modify their own data
- Vocabulary is publicly readable
- Automatic timestamp management with triggers
- Input validation in frontend forms
- Password minimum length enforcement (6 characters)

## Error Handling
The frontend includes error handling for:
- Network failures
- Authentication errors
- Validation errors (empty fields, password mismatch, etc.)
- Invalid credentials
- Database operation failures

All errors are displayed to users via SnackBars.

## Next Steps
1. Run `flutter pub get` to install dependencies
2. Execute the SQL script on Supabase
3. Run the app and test signup/login
4. Test vocabulary search and practice features
5. Monitor user progress tracking

## Troubleshooting

### Issue: "RLS policy violation"
**Solution:** Ensure you're logged in and the user ID matches the record owner.

### Issue: "Supabase initialization failed"
**Solution:** Verify the project URL and publishable key are correct in supabase_service.dart

### Issue: "User not found in users table"
**Solution:** The SQL script should have created all necessary tables. Re-run the SQL script if tables are missing.

### Issue: "Password authentication failed"
**Solution:** Ensure the Supabase project has enabled email/password authentication in Auth settings.

## Notes
- All timestamps are automatically managed by database triggers
- Accuracy is stored as DECIMAL(5, 2) for precision
- Arrays (synonyms, examples, options) use PostgreSQL native array types
- User favorites and progress have unique constraints to prevent duplicates
- Daily streaks are tracked per user with automatic date updates
