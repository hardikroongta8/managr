# Managr

The Productivity App is a Flutter-based application designed to help users set and manage their goals efficiently. It integrates Google Authentication for easy login and provides features to add goals, categorize them, and track progress on a weekly basis. This readme provides an overview of the app's features, installation guide, and basic usage instructions.

## Features

1. **Google Authentication:** Users can log in to the app securely using their Google accounts. This eliminates the need to create a separate account and simplifies the login process.

2. **Goal Management:** Users can add their goals and organize them into categories for better organization and clarity. Each goal can have a title, description, deadline, and priority level.

3. **Categorization:** Goals can be assigned to different categories, allowing users to group related goals together. Common categories may include Personal, Work, Fitness, Education, and more. Users have the flexibility to create custom categories as well.

4. **Progress Tracking:** The app provides a weekly progress view, where users can visualize their goals' progress categorized by week. This feature helps users understand their accomplishments and track their productivity effectively.

## Installation

To install and run the Productivity App, follow these steps:

1. Clone the repository:
   ```
   git clone https://github.com/hardikroongta8/managr.git
   ```

2. Change to the app's directory:
   ```
   cd managr
   ```

3. Install the dependencies:
   ```
   flutter pub get
   ```

4. Configure Firebase project:
   - Create a new Firebase project on the [Firebase Console](https://console.firebase.google.com).
   - Enable Google authentication and generate necessary credentials.
   - Download the `google-services.json` file and place it in the `/android/app` directory.

5. Run the app:
   ```
   flutter run
   ```

## Usage

Upon launching the app, you'll be presented with the login screen. Use your Google account credentials to log in.

### Adding Goals

1. Once logged in, you'll arrive at the home screen.
2. To add a new goal, tap on the "Add Goal" button.
3. Fill in the necessary details such as the goal's title, description, deadline, and priority.
4. Choose a category for the goal or create a new one if desired.
5. Tap on the "Save" button to add the goal.

### Tracking Progress

1. To view your progress, navigate to the "Progress" tab.
2. Here, you'll see your goals categorized by weeks.
3. Select a specific week to view the progress for that week.
4. The progress can be visualized using various metrics like completion percentage, number of goals completed, etc.

### Editing and Deleting Goals

1. To edit a goal, navigate to the home screen and tap on the goal you wish to modify.
2. Make the necessary changes and tap on the "Save" button to update the goal.

To delete a goal, swipe left on the goal in the home screen and tap on the delete icon.

## Feedback and Contributions

We welcome any feedback, suggestions, or contributions to improve the Productivity App. Please feel free to open issues on the GitHub repository or submit pull requests with enhancements or bug fixes.
