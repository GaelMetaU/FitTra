
# FitTra

## Technical Documents
### Recommendation System Breakdown
https://docs.google.com/document/d/1GtSkiZHdKrRyCWwZYN5pzqJ58COriS4027HaUs9X9WQ/edit?usp=sharing  
### Searching and Filtering System Breakdown
https://docs.google.com/document/d/1X7SEDYA5t1R8qmmNwiTbpd-ZhGq1Wlf-Keo7jiQnr0c/edit?usp=sharing
### Views planning and breakdown by components
https://docs.google.com/document/d/1V8hcbNMuMyVMEA8bQD24bnUxQip4Wi4LBqRg1wo4MeE/edit?usp=sharing

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview (#Overview)
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
* A user can see recommended routines on the feed. A ranking algorithm or system will be used
* The session must be saved for users not having to log in everytime
* A user can create an original exercise and save it to build routines with them.
* A user can build an exercising routine specifying which excercise and how many repetitions or how much time, and also assign where can it be done (gym, park or home) and the training level of the routine (beginner, medium or expert).
* A user can see its profile to see their created and liked routines to keep them accesible.
* A user can search for a routine by the routine caption and filtering by training level and place tag
* A user can like another user's routines to save them in their profile
* A user get recommended and look for parks or gyms near them using Google Maps API
* After finding a park or gym, users can tap on it and go to the Google Maps app or website
* A user can add a video to their exercise for other users to see the correct technique

**Optional Nice-to-have Stories**

* Users can tap on another user's profile picture to see their profile with their created routines
* Users can save other user's exercises to build their routines


### 2. Screen Archetypes

* Login 
   * Users can tap on create an account
   * Users can log into the app
   
* Home 
   * Users can see a map view with their current location in which they can search for parks and gyms and visit them on Google Maps
   * Users can see the recommended excercising routines
   * Users can tap on a routine to see the details
   * Users can tap on a heart button to like a routine
   * Users can tap on a button to create a routine
* Create routine
    * Users can create a list of excercises, indicating the name, number of repetitions or time 
    * Users can add a place tag to indicate if the routine is for home, exteriors or a gym
    * Users can add a level tag to indicate if the routine is on a beginner, medium or expert level
    * Users can add a video guide by inserting a Youtube link (optional)
    * Users can tap a button to post the routine
* Add Exercise to routine
    * Users can pick an exercise to add to their routine
    * Users can tap a button to create a new exercise
* Create exercise
    * Users can upload a video view of their exercise 
    * Users can uplaod a photo of their exercise
    * Users can name and specify the body zone target of their new exercise
    * Users can save that exercise to their account
* Routine details
    * Users can see the details of the routine, time, reps, the workout place and training level
    * Users can tap on the author's profile picture to visit it's profile
    * Users can tap on an exercise to see a video view of it
    * Users can tap on the heart button to like the routine
* Exercise details
    * Users can see the exercise information
    * Users can see a video preview of the exercise
* Search 
    * Users can type in a search bar the part of the body they want to excercise
    * Users can apply filters to their search depending on the training level or the workout place 
    * Users can type in a search bar the part of the body they want to excercise
    * Users can see in a table view the results of their search
    * Users can tap on a routine to see the details
* Profile 
    * Users can see their saved routines
    * Users can see their own routines
    * Users can log out
    * Users can change their profile picture
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
| objectID           | String | Object Identifier (default)               |
| createdAt          | Date   | Creation date (default)                   |
| updatedAt          | Date   | Last modification date (default)          |
| email              | String | Email associated to the account (default) |
| username           | String | User's nickname on screen                 |
| profilePicture     | PFFile | User's profile picture                    |
| password           | String | User's account password (default)         |
| trainingLevel      | Number | User's training level                     |
| workoutPlace       | Number | User's preferred workout place            |


**Routine**

| Property                      | Type           | Description                                             |
| ----------------------------- | -------------- | ------------------------------------------------------- |
| objectID                      | String         | Object Identifier (default)                             |
| createdAt                     | Date           | Creation date (default)                                 |
| updatedAt                     | Date           | Last modification date (default)                        |
| author                        | Pointer <User> | Reference to the routine's creator                      |
| likeCount                     | Number         | Number of users who liked the post                      |
| bodyZoneTags                  | Array          | Tags to the bodyzone the routine is focused             |
| title                         | String         | Name or identifier of the routine                       |
| caption                       | String         | Any comment or note the author leaves                   |
| image                         | PFFile         | Any comment or note the author leaves                   |
| standardizedCaption           | String         | Any comment or note the author leaves                   |
| standardizedAuthorUsername    | String         | Any comment or note the author leaves                   |
| exerciseList                  | Array          | Array of ExerciseInRoutine objects                      |
| workoutPlace                  | Number         | Tag to say if the routine is for gym, home or park      |
| trainingLevel                 | Number         | Tag to say if the routine is beginner, medium or expert |
| interactionScore              | Number         | Total interaction generated by the post                 |
| homeUsersInteractionScore     | Number         | Interaction with users with home place tag              |
| parkUsersInteractionScore     | Number         | Interaction with users with park place tag              |
| gymUsersInteractionScore      | Number         | Interaction with users with gym place tag               |
| beginnerUsersInteractionScore | Number         | Interaction with users with beginner training level tag |
| mediumUsersInteractionScore   | Number         | Interaction with users with medium training level tag   |
| expertUsersInteractionScore   | Number         | Interaction with users with expert training level tag   |


**LikedRoutines**

| Property  | Type              | Description                      |
| --------- | ----------------- | -------------------------------- |
| objectID  | String            | Object Identifier (default)      |
| createdAt | Date              | Creation date (default)          |
| updatedAt | Date              | Last modification date (default) |
| user      | Pointer <User>    | User that liked the routine      |
| routine   | Pointer <Routine> | Routine liked                    |


**ExcerciseInRoutine**

| Property     | Type               | Description                                        |
| ------------ | ------------------ | -------------------------------------------------- |
| amountUnit   | Number             | Tag to specify seconds, minutes or reps            |
| amount       | Number             | Amount of either seconds, minutes or reps          |
| numberOfSets | Number             | Amount of either seconds, minutes or reps          |
| baseExercise | Pointer <Exercise> | Tag to the exercise model to get videos, name, etc |


**Exercise**

| Property     | Type                  | Description                                  |
| ------------ | --------------------- | -------------------------------------------- |
| objectID     | String                | Object Identifier (default)                  |
| createdAt    | Date                  | Creation date (default)                      |
| updatedAt    | Date                  | Last modification date (default)             |
| title        | String                | User Identifier (default)                    |
| author       | Pointer <User>        | Reference to the exercise's creator          |
| video        | PFFile                | Exercise's video                             |
| image        | PFFile                | Exercise's image                             |
| bodyZoneTag  | Pointer <BodyZoneTag> | Tags to the bodyzone the exercise is focused |


**SavedExercise**

| Property  | Type               | Description                      |
| --------- | ------------------ | -------------------------------- |
| objectID  | String             | Object Identifier (default)      |
| createdAt | Date               | Creation date (default)          |
| updatedAt | Date               | Last modification date (default) |
| user      | Pointer <User>     | User that liked the routine      |
| exercise  | Pointer <Exercise> | Routine liked                    |


**BodyZone**

| Property     | Type       | Description                      |
| ------------ | ---------- | -------------------------------- |
| objectID     | String     | User Identifier (default)        |
| createdAt    | Date       | Creation date (default)          |
| updatedAt    | Date       | Last modification date (default) |
| icon         | PFFile     | Image representing the body zone |
| title        | String     | Name of the body zone            |



### Networking
##### Requests by screen
* Login
    * User authentication
* Register
    * User sign up
* Home
    * Get recommended routines
    * Like a routine
    * Get Google Maps View
    * Get Google Places API nearby places search
    * Get Google Places SDK place details
* Profile
    * Get user's created routines
    * Get user's liked routines
    * Change profile picture update request
    * User Log out
* Routine Details
    * All data will come from the home feed, so no requests here
* Exercise Details
    * All data will come from the home feed, so no requests here
* Search
    * Get user's request results based on the searching system
* Create Routine
    * Adding a routine to the database
* Add Exercise
    * Get user's exercises
* Create Exercise
    * Get body zones
    * Adding an exercise to the database
    
##### API's to be used
* Google Maps API: Allows displaying a map and pinging locations. It also has better synergy with the Places API
* Google Places API: Gives access to a huge list of places which will be used to retrieve parks and gyms near the user's location and display them in the map.
* Parse: Parse own API and pod to pull all user data and posts.
  

