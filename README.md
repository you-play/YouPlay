# YouPlay


## Table of Contents

1. [Overview](#Overview)
2. [Product Spec](#Product-Spec)
3. [Wireframes](#Wireframes)
4. [Schema](#Schema)

## Overview

### Description

This app is a streamlined music streaming service that generates playlists based on the user's current mood.
Upon opening the app, users select their mood, and a curated playlist that matches their selection is immediately suggested.

### App Evaluation

- **Category:** Music streaming, social
- **Mobile:** Yes
- **Story:** Tailored for those who seek music to match and amplify their emotions—whether it's for comfort, motivation, relaxation, or energy.
- **Market:** Individuals who own an iOS device and are willing to stream music. 
- **Habit:** Users are meant to use the app throughout their day.
- **Scope:** Our goal is to develop an MVP with a short scope of features and work from there. Focused on making the app functional and user friendly.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

**As a** user  
**I want** to select my current mood from a _select_ list of songs (based on energy, danceability...)
**so I can** quickly receive a playlist that matches how I'm feeling.

**As a** user  
**I want** to be able to play, pause, skip songs (no shuffle, foward and backward) in the playlist  
**so I can** bypass tracks that don't quite fit my mood or take a break.

**As a** user  
**I want** to discover new music tailored to my mood  
**so I can** expand my musical tastes while staying within the emotional context I prefer.

**As a** user  
**I want** to save playlists generated based on my mood  
**so I can** listen to them again later.

**As a** user  
**I want** to see the name of the currently playing song and its artist  
**so I can** explore more from artists I like.

**As a** user  
**I want** to adjust the number of songs on the playlist based on my available time  
**so that** the music lasts for my desired listening period.

**As a** user  
**I want** to be able to "Like" tracks and have a "Liked Tracks" playlist automatically generated 
**so I can** improve future playlist recommendations.

**As a** user  
**I want** to provide feedback on playlist suggestions  
**so that** the app can refine its future recommendations for me.

**Optional Nice-to-have Stories**

**As a** user  
**I want** to create custom moods  
**so I can** have even more personalized playlists that reflect my unique feelings.

**As a** user  
**I want** to combine multiple moods into a single playlist  
**so I can** enjoy a mix that reflects my complex emotional state.

**As a** user  
**I want** to set mood-based alarms  
**so I can** wake up or be reminded with music that fits how I want to feel.

**As a** user  
**I want** to see visualizations or artwork that match the mood of the current playlist  
**enhancing my listening experience.**

**As a** user  
**I want** the option to filter songs by language or genre within a mood category  
**so I can** tailor the music even further to my 

## 2. Screen Archetypes
* Login Screen
    * As a user I must be able to login 
* Signup Screen
    * As a user I must be able to create an account
* Profile screen
    * As a logged in user, I should be able to click on my avatar and be taken to a profile screen.
* Mood Selector 
    * As a logged in user I want to be prompted to select the mood I am in
* Suggested Songs Screen
    * As a logged in user I want to be able to see several songs that
* Unique Song Screen
    * As a user I want to be able to click on a song cover and see the song in full screen.
    * As a user I would like to navigate through a song 
* My Playlist Screen 
    * As a logged in user I want to be able to see all of my playlists

* Unique Playlist Screen
    * As a logged in user I want to be able to be able to browse through the songs in my playlist.
* Search bar
    * As a logged in user, I should be able to search for songs.
      
### 3. Navigation

**Tab Navigation** (Tab to Screen)

- [ ] Home
- [ ] Search
- [ ] Playlists

**Flow Navigation** (Screen to Screen)

- [ ] `Login/Signup`
  * Leads to `Home`
- [ ] `Profile` (after clicking "Log out")
  * Leads to `Login/Signup`
- [ ] `Home` (after clicking a `Playlist`)
  * Leads to `Playlist` screen for it
- [ ] `Home` (after clicking a `Song`)
  * Leads to `Song/Playback` (bottom sheet) for it
- [ ] `Song/Playback` (after dismissing a `Song` _bottom sheet_)
  * Leads to `Home`
- [ ] `Song/Playback` (after hitting "Add to Playlist" button`)
  * Leads to `PlaylistSelection` _bottom sheet_

## Wireframes

![Wireframe](Codepath Final Project Wireframe.png)

### [BONUS] Digital Wireframes & Mockups

<img width="612" alt="image" src="https://github.com/ios-102/YouPlay/assets/45319275/29c28f40-d564-4dac-af25-9d52c891cf6f">

## Schema 

### Models

[Model Name, e.g., User]
| Property | Type   | Description                                  |
|----------|--------|----------------------------------------------|
| username | String | unique id for the user post (default field)   |
| password | String | user's password for login authentication      |
| ...      | ...    | ...                          


### Networking

- [List of network requests by screen]
- [Example: `[GET] /users` - to retrieve user data]
- ...
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
