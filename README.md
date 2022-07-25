
# Gym Buddies

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
An app where you can create excercising routines and share them, you can see other users' routines and like them or save them for you to use them later. You can visit other user's profiles if you liked its routines and follow them for you to know when it posts another routine.
Also, a routine can be set to be done from home, in a park or in a gym, so you can be recommended the nearest place for you to do it or look for them in the map.

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Health, lifestyle and fitness.
- **Mobile:** Excercising is something you don't do next to a laptop or desktop computer, but next to your phone, so making it a mobile app is a key aspect to make it practical and useful. Users could access their live location to search for gyms and parks to workout, also, they could be shown videos from the app to see how to correctly do the excercises.
- **Story:** Helping people get into excercise and workout is very positive for all users, a lot of people want to stay in form, but they don't know what excercises are best or how to mix them into a routine and are shy to ask, so a platform to make that easy can avoid people from quitting and go back to unhealthy habits.
- **Market:** Every person who has an interest in excercise and workouts, the target group is young adults who want to add excercising habits to their routine.
- **Habit:** It can become part of the users' daily routine, as they could spend some time searching for routines to do everyday or look at their saved ones.
- **Scope:** An efficient design for the routine builder might be a challenge, as well as creating the correct database design. There are a lot of nice-to-have features, but the core feature that is the routine builder is the main attractive of the project.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* A user can login
* A user can see recommended routines on the feed. A ranking algorithm or system will be used (To be decided)
* The session must be saved for users not having to log in everytime
* A user can create original exercise and save it to build routines with them.
* A user can build an exercising routine specifying wich excercise, (from the default library or an original one) and how many repetitions or how much time, and also assign where can it be done (gym, park or home).
* A user can see its profile to see their own routines
* A user can search for a routine depending on a particular body zone or excercise
* A user can like another user's routines to save them in its profile
* A user get recommended and look for parks or gyms near it using Google Maps API
* A user can add videos to their routine by using Youtube's API

**Optional Nice-to-have Stories**

* A user can filter it's own routines to look for a specific one.
* A user can filter it's liked routines to look fo a specific one.
* A user can follow other users to stay tuned of their posts.
* A user can get recommendations for places to excercise nearby.
* A user can save exercises from other routines to later build routines with them.
* Being able to add friends to workout together, you can send routines to the group or chat 

### 2. Screen Archetypes

* Login 
   * Users can tap on create an account
   * Users can log into the app
* Home 
   * Users can see the recommended excercising routines
   * Users can click on their profile picture to visit their profile
   * Users can tap on a routine to see the details
   * Users can double tap to save a routine
   * Users can tap on a button to create a routine
* Create routine
    * Users can create a list of excercises, indicating the name, number of repetitions or time 
    * Users can add a place tag to indicate if the routine is for home, exteriors or a gym
    * Users can add a video guide by inserting a Youtube link (optional)
    * Users can tap a button to post the routine
* Details
    * Users can see the details of the routine, time, reps, where to do it
    * Users can tap on the author's profile picture to visit it's profile
    * Users can double tap to save the routine
* Search 
    * Users can type in a search bar the part of the body they want to excercise
    * Users can see in a table view the results of their search
    * Users can tap on a routine to see the details
* Profile 
    * Users can see their saved routines
    * Users can see their own routines
    * Users can tap on a button to create a routine


### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Home Screen
* Create Routine
* Profile
* Buddies group  **(STRETCH FEATURE)**

**Flow Navigation** (Screen to Screen)

* Log in -> Home
* Home -> Routine Details
* Profile -> My Routines / Liked Routines -> Routine Details
* Search -> Routine Details
* Create -> Home (Either if canceled post or completed it)
* Buddies -> Add buddy / Chat view  **(STRETCH FEATURE)**


### 4. Complex problems
* Routine recommendation system
* Routine searching system

## Wireframes

#### Figma prototype
https://www.figma.com/file/rEp679zAVBdmXpQH7HhDaI/Untitled?node-id=3%3A3


## Schema 

### Models

**User**

| Property           | Type   | Description                               |
| ------------------ | ------ | ----------------------------------------- |
| objectID           | String | User Identifier (default)                 |
| createdAt          | Date   | Creation date (default)                   |
| updatedAt          | Date   | Last modification date (default)          |
| email              | String | Email associated to the account (default) |
| username           | String | User's nickname on screen                 |
| password           | String | User's account password (default)         |
| likedRoutines      | Array  | User's saved routines                     |
| exercisesInRoutine | Array  | User's saved exercises                    |
| skillLevel         | Int    | User's skill level                        |
| workoutPlace       | Int    | User's preferred workout place            |


**Routine**

| Property      | Type           | Description                                        |
| ------------- | -------------- | -------------------------------------------------- |
| objectID      | String         | User Identifier (default)                          |
| createdAt     | Date           | Creation date (default)                            |
| updatedAt     | Date           | Last modification date (default)                   |
| author        | Pointer <User> | Reference to the routine's creator                 |
| likeCount     | Int            | Number of users who liked the post                 |
| bodyZoneTags  | Array          | Tags to the bodyzone the routine is focused        |
| title         | String         | Name or identifier of the routine                  |
| caption       | String         | Any comment or note the author leaves              |
| exercises     | Array          | Array of exercises that compose the routine        |
| workoutPlace  | Int            | Tag to say if the routine is for gym, home or park |
| trainingLevel | Int            | Tag to say if the routine is for gym, home or park |


**ExcerciseInRoutine**

| Property     | Type               | Description                                        |
| ------------ | ------------------ | -------------------------------------------------- |
| Reps         | Bool               | True for reps, false for time                      |
| amountUnit   | String             | Specify seconds, minutes or reps                   |
| amount       | Integer            | Amount of either seconds, minutes or reps          |
| baseExercise | Pointer <Exercise> | Tag to the exercise model to get videos, name, etc |


**Exercises**

| Property     | Type                  | Description                                        |
| ------------ | --------------------- | -------------------------------------------------- |
| objectID     | String                | User Identifier (default)                          |
| createdAt    | Date                  | Creation date (default)                            |
| updatedAt    | Date                  | Last modification date (default)                   |
| author       | Pointer <User>        | Reference to the exercise's creator                |
| video        | String                | URL to the video                                   |
| bodyZoneTag  | Pointer <BodyZoneTag> | Tags to the bodyzone the exercise is focused       |


**BodyZones**

| Property     | Type       | Description                                        |
| ------------ | ---------- | -------------------------------------------------- |
| objectID     | String     | User Identifier (default)                          |
| createdAt    | Date       | Creation date (default)                            |
| updatedAt    | Date       | Last modification date (default)                   |
| icon         | File       | Image representing the body zone                   |
| title        | String     | Name of the body zone                              |



### Networking
##### Requests by screen
* Login
    * User authentication
* Home
    * Get recommended routines
    * Get Google Maps View
* Profile
    * Get user's information
    * Get user's routines
    * Get user's liked routines
    * User Log out
* Details
    * All data will come from the home feed, so no requests here
* Search
    * Get user's request results based on the algortihm or system designed
* Create Routine
    * Adding a routine to the database
* Add Exercise
    * Get user's exercises
* Create Exercise
    * Get body zone icons
    * Adding an exercise to the database
    
##### API's to be used
* Google Maps API: Allows displaying a map and pinging locations. It also has better synergy with the Places API
* Google Places API: Gives access to a huge list of places which will be used to retrieve parks and gyms near the user's location and display them in the map.
* Parse: Parse own API and pod to pull all user data and posts.
