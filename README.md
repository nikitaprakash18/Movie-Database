# Movie Database

##### Movie Database is a movies app using the [The Movie Database API](https://developers.themoviedb.org)

# User Stories

The following functionality is completed:

1. User has to register for the first time, subsequently they can login using login flow.
2. User can even login as guest without username & password.
3. User has the option to reset password using reset password flow.
4. User can view a list of popular and top rated movies movies. Poster images load asynchronously.
5. Implemented search Bar to filter movies based on the names.
5. User can view movie details by tapping on a cell.
6. User sees loading state while waiting for the API.
7. User can pull to refresh the movie list.
8. All data are stored in FireBase and even data are available offline.
9. User has option to signout if your not a guest user.

# Getting Started

To get started and run the app, you need to follow these simple steps:

1. Git clone or download the repository onto your machine.
2. Open the Movie Database workspace in Xcode.
3. Change the Bundle Identifier to match your domain.
4. Go to Firebase and create new project.
5. Select "Add Firebase to your iOS app" option, type the bundle Identifier & click continue.
6. Download "GoogleService-Info.plist" file and add to the project. Make sure file name is "GoogleService-Info.plist".
7. Go to Firebase Console, select your project, choose "Authentication" from left menu, select "SIGN-IN METHOD" and enable "Email/Password" option.
8. Open the terminal, navigate to project folder and run "pod update".
9. You're all set! Run Movie Database on your iPhone or the iOS Simulator.

Compatibility

This project is written in Swift 4.2 and requires Xcode 10.1 to build and run.

# Demo

[Gif](https://drive.google.com/file/d/1LkBt-ec3n3VwM_B48PIRUtk4rpns8Ph3/view?usp=sharing)
