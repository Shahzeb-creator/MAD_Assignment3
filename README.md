# Flutter Authentication App — Course API Integration (Extension)

This branch extends the existing multi-screen authentication app (Register,
Login, Dashboard) with full CRUD integration for a "Courses" feature backed
by a real REST API.

## Branch

`feature/course-api-integration`

## API Used

**[JSONPlaceholder](https://jsonplaceholder.typicode.com/)** — a free fake
REST API for testing and prototyping.

This app uses the `/posts` resource to represent courses:

| JSONPlaceholder field | Mapped to       |
|------------------------|-----------------|
| `id`                   | Course id       |
| `title`                | Course title    |
| `body`                 | Course description |
| `userId`               | Course `userId` (kept for valid request payloads) |

Documentation followed: <https://jsonplaceholder.typicode.com/guide>

> Note: JSONPlaceholder is a fake API. `POST`, `PUT`, and `DELETE` requests
> all return valid success responses, but nothing is actually persisted on
> the server (every `POST` echoes back `id: 101`, for example). This is
> expected, documented behaviour — the app updates its own local state
> after each successful response so changes are reflected in the UI.

## What Was Added

- **`lib/models/course.dart`** — `Course` model with `fromJson` / `toJson`.
- **`lib/services/course_service.dart`** — API service layer. All HTTP
  calls (`GET`, `POST`, `PUT`, `DELETE`) live here, completely separate
  from UI code.
- **`lib/Screens/courses.dart`** — main Courses screen:
  - Fetches and lists courses (**Read**)
  - Shows a loading spinner while fetching
  - Shows an error state with a **Retry** button on failure
  - Add (+) button to create a course (**Create**)
  - Edit icon per row, opening a pre-filled form (**Update**)
  - Delete icon per row, with a confirmation dialog before deleting
    (**Delete**)
  - Pull-to-refresh and a manual refresh button
- **`lib/Screens/course_form.dart`** — shared Add/Edit form screen with
  validation.
- **`lib/Screens/dashboard.dart`** — added a "Manage Courses (API)" button
  that opens the new Courses screen. No existing functionality (login,
  register, navigation, validation) was changed.
- **`pubspec.yaml`** — added the `http` package dependency.

## Architecture

- All network calls go through `CourseService` — no `http` calls happen
  directly inside any widget.
- UI screens (`courses.dart`, `course_form.dart`) only know about the
  `Course` model and `CourseService`'s public methods; they never touch
  raw JSON.
- Loading / success / error states are tracked explicitly in
  `CoursesScreen` and rendered accordingly.

## How to Run

```bash
flutter pub get
flutter run
```

From the Dashboard screen, tap **Manage Courses (API)** to reach the new
CRUD screen.

## Screenshots

_Add screenshots here before submission:_

- [ ] Courses list (loading state)
- [ ] Courses list (loaded)
- [ ] Add Course form
- [ ] Edit Course form (pre-filled)
- [ ] Delete confirmation dialog
- [ ] Error state (e.g. with airplane mode on)


## Extension Assignment Upgrade

- State Management: Provider
- Local Storage: SharedPreferences
- Architecture: UI → Provider → Repository → API Service → Local Storage
- Branch: feature/offline-cache-and-state-manangement
- Offline support implemented by caching API responses locally.
- Optimistic UI supported for update/delete operations.
