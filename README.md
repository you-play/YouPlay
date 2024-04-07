# YouPlay <!-- omit from toc -->

## Overview

### Description <!-- omit from toc -->

YouPlay is a streamlined music streaming service that generates playlists based on the user's current mood.

Upon opening the app, users select their mood, and a curated playlist that matches their selection is immediately suggested.

### App Evaluation <!-- omit from toc -->

- **Category:** Music streaming, social
- **Story:** Tailored for those who seek music to match and amplify their emotions—whether it's for comfort, motivation, relaxation, or energy.
- **Market:** Individuals who own an iOS device and are willing to stream music.
- **Habit:** Users are meant to use the app throughout their day.
- **Scope:** Our goal is to develop an MVP with a short scope of features and work from there. Focused on making the app functional and user-friendly.
-

## Table of Contents <!-- omit from toc -->

- [Overview](#overview)
- [Technologies](#technologies)
- [Getting Started](#getting-started)
- [Project Board](#project-board)
- [Demos](#demos)
  - [Auth Flow](#auth-flow)
  - [Player Crumb-bar](#player-crumb-bar)
  - [Search Bar](#search-bar)
  - [Playlist Flow](#playlist-flow)
- [Product Spec](#product-spec)
- [Screen Archetypes](#screen-archetypes)
  - [Navigation](#navigation)
- [Wireframes](#wireframes)
- [Schema](#schema)
  - [Models](#models)
  - [Networking](#networking)

## Technologies

- **Language:** Swift
- **iOS Framework:** SwiftUI
- **Auth:** Firebase Auth
- **Music Playback:** Spotify iOS SDK
- **Song Metadata:** Spotify Web API
- **Database**
  - **NoSQL:** Firebase Firestore
  - **Object Storage:** Firebase Storage

## Getting Started

### 1. Create a Spotify API application <!-- omit from toc -->

Head over to your [Spotify Dashboard](https://developer.spotify.com/dashboard/) and register a new application.

**App name:** `YouPlay`

**App description:** `A mood based music streaming service.`

**Website:** _Can be left empty_

**Redirect URI:** `spotify-ios-you-play://spotify-login-callback`

**Which API/SDKs are you planning to use?**

- [x] `Web API`
- [x] `iOS`

After you have done the initial setup, open the app's `Settings` and add the following **iOS app bundles**:

- `com.you-play.YouPlay`

Your settings should be similar to [this.](./assets//docs/spotify_app_dashboard.png)

Lastly, make sure the [App bundle](./assets/docs/bundle_id.png) within `XCode` matches above.

### 2. Run the App Locally <!-- omit from toc -->

1. Clone the repo: `git clone https://github.com/you-play/YouPlay/`
2. Download the `GoogleService-Info.plist` and `SpotifyService.plist` from our [Google Drive](https://drive.google.com/drive/u/0/folders/1mpas-2XIVRFXT4UJKt6yppe0XE1tgUjC)
3. Replace the `CLIENT_ID` and `CLIENT_SECRET` in the `SpotifyService.plist` with your own Spotify credentials
4. Add the `GoogleService-Info.plist` and `SpotifyService.plist` into `/ios-app/YouPlay/` folder
5. Build and start the app in `Xcode`

## Project Board

![project board 1](./assets//screenshots/project-board-1.png)

## Demos

### Auth Flow

- Complete auth flow (log in, sign up, logout) using email and password alongside Google OAuth.

- Users are able to update their profile picture and have it uploaded directly to Firebase Storage.

- Password reset available via email.

![auth flow demo](./assets/demos/demo-auth-flow.gif)

### Player Crumb-bar

- Users able to view the song that's currently playing
- Users can click on the crumb-bar and open the details for that specific song

![player crumbar](./assets/demos/demo-player-crumbar.gif)

### Search Bar

- Users able to search for songs

![search bar](./assets/demos/demo-search-bar.gif)

### Playlist Flow

- Users are able to:
  - Play any song they like
  - Add any song to a playlist (if it's not a duplicate
- Playlists are kept up-to-date by `lastModified` date
- Playlist have the image of the last song added to it
- Users can refresh their playlists

![playlist flow](./assets/demos/demo-playlist-flow.gif)

## Product Spec

### User Stories <!-- omit from toc -->

#### Required Must-have Stories <!-- omit from toc -->

**As a** user,
**I want** to select my current mood from a _select_ list of songs (based on energy, and dance-ability...)
**so I can** quickly receive a playlist that matches how I'm feeling.

**As a** user,
**I want** to be able to play, pause, and skip songs (no shuffle, forward and backward) in the playlist
**so I can** bypass tracks that don't quite fit my mood or take a break.

**As a** user,
**I want** to discover new music tailored to my mood
**so I can** expand my musical tastes while staying within the emotional context I prefer.

**As a** user,
**I want** to save playlists generated based on my mood
**so I can** listen to them again later.

**As a** user,
**I want** to see the name of the currently playing song and its artist
**so I can** explore more from artists I like.

**As a** user,
**I want** to adjust the number of songs on the playlist based on my available time
**so that** the music lasts for my desired listening period.

**As a** user,
**I want** to be able to "Like" tracks and have a "Liked Tracks" playlist automatically generated
**so I can** improve future playlist recommendations.

**As a** user,
**I want** to provide feedback on playlist suggestions
**so that** the app can refine its future recommendations for me.

#### Optional (Nice-to-have Stories) <!-- omit from toc -->

**As a** user,
**I want** to create custom moods
**so I can** have even more personalized playlists that reflect my unique feelings.

**As a** user,
**I want** to combine multiple moods into a single playlist
**so I can** enjoy a mix that reflects my complex emotional state.

**As a** user,
**I want** to set mood-based alarms
**so I can** wake up or be reminded with music that fits how I want to feel.

**As a** user,
**I want** to see visualizations or artwork that match the mood of the current playlist **so I can**
enhance my listening experience.

**As a** user,
**I want** the option to filter songs by language or genre within a mood category
**so I can** tailor the music even further to my

## Screen Archetypes

- Login Screen
  - As a user, I must be able to log in
- Sign-up Screen
  - As a user, I must be able to create an account
- Profile screen
  - As a logged-in user, I should be able to click on my avatar and be taken to a profile screen.
- Mood Selector
  - As a logged-in user, I want to be prompted to select the mood I am in
- Suggested Songs Screen
  - As a logged-in user, I want to be able to see several songs that
- Unique Song Screen
  - As a user, I want to be able to click on a song cover and see the song in full screen.
  - As a user, I would like to navigate through a song
- My Playlist Screen
  - As a logged-in user, I want to be able to see all of my playlists
- Unique Playlist Screen
  - As a logged-in user, I want to be able to be able to browse through the songs in my playlist.
- Search bar
  - As a logged-in user, I should be able to search for songs.

### Navigation

**Tab Navigation** (Tab to Screen)

- [x] Home
- [x] Search
- [x] Playlists

**Flow Navigation** (Screen to Screen)

- [x] `Login/Sign-up`
  - Leads to `Home`
- [x] `Profile` (after clicking "Log out")
  - Leads to `Login/Sign-up`
- [x] `Home` (after clicking a `Playlist`)
      Leads to the `Playlist` screen for it
- [x] `Home` (after clicking a `Song`)
  - Leads to `Song/Playback` (bottom sheet) for it
- [x] `Song/Playback` (after dismissing a `Song` _bottom sheet_)
  - Leads to `Home`
- [x] `Song/Playback` (after hitting the "Add to Playlist" button)
  - Leads to `PlaylistSelection` _bottom sheet_

## Wireframes

![Screenshot 2024-03-09 at 10 52 56 PM](https://github.com/ios-102/YouPlay/assets/83348928/a315059b-b9ea-4975-bfd9-54f8e22d0653)

### Digital Wireframes <!-- omit from toc -->

![Hand-made wire-frames](https://github.com/ios-102/YouPlay/assets/45319275/29c28f40-d564-4dac-af25-9d52c891cf6f)

## Schema

### Models

`User` model

| Property        | Type    | Description                                          |
| --------------- | ------- | ---------------------------------------------------- |
| uid             | String? | Firestore ID                                         |
| username        | String  | Username of the user                                 |
| email           | String  | Email of the user                                    |
| id              | String  | Unique identifier (fallback to UUID if `uid` is nil) |
| age             | Int?    | Age of the user (optional)                           |
| gender          | Gender? | Gender of the user (enum or optional string)         |
| profileImageUrl | String? | URL of the user's profile image (optional)           |

`Player` model:

| Property     | Type    | Description                                  |
| ------------ | ------- | -------------------------------------------- |
| repeatState  | String  | State of repeat functionality                |
| shuffleState | Bool    | State of shuffle functionality               |
| isPlaying    | Bool    | Indicates if a song is currently playing     |
| song         | Song    | Information about the currently playing song |
| actions      | Actions | Actions that can be performed on the player  |

`Actions` model:

| Property              | Type | Description                                       |
| --------------------- | ---- | ------------------------------------------------- |
| interruptingPlayback  | Bool | Indicates if playback is being interrupted        |
| pausing               | Bool | Indicates if playback is being paused             |
| resuming              | Bool | Indicates if playback is being resumed            |
| seeking               | Bool | Indicates if seeking within the playback          |
| skippingNext          | Bool | Indicates if skipping to the next track           |
| skippingPrev          | Bool | Indicates if skipping to the previous track       |
| togglingRepeatContext | Bool | Indicates toggling repeat for the current context |
| togglingShuffle       | Bool | Indicates toggling shuffle mode                   |
| togglingRepeatTrack   | Bool | Indicates toggling repeat for the current track   |
| transferringPlayback  | Bool | Indicates if playback is being transferred        |

`Album` model

| Property    | Type         | Description                                   |
| ----------- | ------------ | --------------------------------------------- |
| albumType   | String       | Type of the album (e.g., "album", "single")   |
| totalTracks | Int          | Total number of tracks in the album           |
| href        | String       | URL of the album                              |
| id          | String       | Unique identifier of the album                |
| images      | [AlbumImage] | Array of images representing the album        |
| name        | String       | Name of the album                             |
| uri         | String       | Spotify URI of the album                      |
| artists     | [Artist]     | Array of artists who contributed to the album |
| tracks      | Tracks       | Information about the tracks in the album     |
| popularity  | Int          | Popularity score of the album                 |

`SpotifyImage` model

| Property | Type   | Description                         |
| -------- | ------ | ----------------------------------- |
| url      | String | URL of the album image              |
| height   | Int?   | Height of the album image in pixels |
| width    | Int?   | Width of the album image in pixels  |

`Artist`model

| Property | Type   | Description                     |
| -------- | ------ | ------------------------------- |
| id       | String | Unique identifier of the artist |
| name     | String | Name of the artist              |

`Song` model

| Property   | Type     | Description                                    |
| ---------- | -------- | ---------------------------------------------- |
| documentID | String?  | Firestore document ID                          |
| title      | String   | Title of the song                              |
| artists    | [String] | Array of artist names contributing to the song |
| imageURL   | String   | URL of the image representing the song         |
| id         | String   | Unique identifier for the song                 |

`TracksResponse` model

| Property | Type   | Description                                      |
| -------- | ------ | ------------------------------------------------ |
| items    | [Song] | Array of song responses representing tracks      |
| limit    | Int    | Maximum number of items returned in the response |
| offset   | Int    | Offset for the paginated response                |
| total    | Int    | Total number of items available                  |

### Networking

#### Spotify Service <!-- omit from toc -->

- func getAccessToken() async -> String?
- func search(text: String) async -> SpotifySearchResponse?

#### Authorization Service <!-- omit from toc -->

- `func login(email: String, password: String) async throws`
- `func loginWithGoogle() async throws`
- `func createUser(email: String, password: String) async throws`
- `func logout()`
- `func resetPassword(email: String) async throws`

#### Storage Service <!-- omit from toc -->

- ````func uploadImage(bucket: StorageBuckets, fileName: String, imageData: Data, fileExtension: ImageFileExtension)
  async throws -> String```
  ````

#### UserService <!-- omit from toc -->

- `func getUserMetadata(uid: String) async throws -> User?`
- `func updateUserMetadata(uid: String, user: User) async throws`
- `func updateProfileImage(uid: String, imageData: Data) async throws`

#### PlaylistService <!-- omit from toc -->

- `func setupDefaultPlaylists(uid: String) async -> Void`
  `func getPlaylists(uid: String) async -> [Playlist]`
- `func getPlaylist(uid: String, playlistId: String) async -> Playlist?`
- `func getTopPlaylists(uid: String, limit: Int) async -> [Playlist]`
- `func createPlaylist(uid: String, name: String) async`
- `func deletePlaylist(uid: String, playlistId: String) async`
- `func removeSongFromPlaylist(uid: String, playlistId: String, songId: String) async`
- `func getPlaylistIdToSongsMap(for playlists: [Playlist]) async -> [String: [Song]]`
- `func addSongToPlaylist(uid: String, playlistId: String, song: Song) async`

#### PlaybackService <!-- omit from toc -->

- `play(uri: String)`
- `pauseOrPlay()`
- `connect()`
- `disconnect()`
- `previous()`
- `next()`
