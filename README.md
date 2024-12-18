# L2Play

![Swift](https://img.shields.io/badge/swift-F54A2A?style=for-the-badge&logo=swift&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-039BE5?style=for-the-badge&logo=Firebase&logoColor=white)

L2Play is simple social media application, which connects people sharing same passion - gaming. It enables its users to rate the games they have already played, read reviews from other people and of course write their own.

## About

This project follows the `MVVM` pattern. Firebase is used as the backend solution, allowing us to focus on the mobile app. Below is a short description of the **main** directories:

- **`Views/`** – Contains the view components.

- **`ViewModels/`** – Contains classes that handle business logic.
- **`Services/`** – Includes the following components:

  - **`Firebase/`** – Classes for communication with Firebase.

  - **`Translation/`** – A service that will handle multi-language support (replacing the use of _Localized.strings_ in the future).
  - **`Recommendation/`** – A class that helps recommend games to the user.
  - **`Cdn/`** – Responsible for communication with the content API.
  - **`EnvVars/`** – Handles environment variables.

- **`Components/`** – Reusable UI components.
- **`Models/`** – Data models used for managing and processing data.

## Functionalities

- :speech_balloon: Real time messages (?)
- :iphone: Sign up, sign in (avaiable authentication via Google)
- :clock9: Adding games to "Playlist" (Play later)
- :heavy_plus_sign: Following friends and other critics
- :busts_in_silhouette: Managing followers
- :heavy_check_mark: Marking games you have already played
- :star: Rating and writing reviews about games
- :pencil: Writing comments on other people's reviews
- :globe_with_meridians: Account managing
- :no_entry_sign: User blocking
- :key: Password restoring
- :gb: Handling other languages based on the locations
- :triangular_flag_on_post: Censorship of profanity
- :bell: Notifications
- :bulb: Recomendations
