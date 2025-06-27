# **BETA TEST PLAN – EvolOs**

*This Beta Test Plan is divided into two main sections.*

- [A - Mobile Application;](https://www.notion.so/Beta-Test-Plan-1de8562ccb9080158b49c4772b9ff5e8?pvs=21)
- [B - Dashboard Web Interface.](https://www.notion.so/Beta-Test-Plan-1de8562ccb9080158b49c4772b9ff5e8?pvs=21)

*Each containing its own parts*

---

## **A - Mobile Application**

This part of the Beta Test Plan focuses on the EvolOs mobile application, which is our main interface, used by ['learners'](https://www.notion.so/Beta-Test-Plan-1de8562ccb9080158b49c4772b9ff5e8?pvs=21).

### **1. Core Functionalities for Beta Version**

| **Feature Name** | **Description** | **Priority (High/Medium/Low)** | **Changes Since Tech3** |
| --- | --- | --- | --- |
| Roadmap Island | Main screen inspired by Duolingo's roadmap where each "island" represents a course or an evaluation.<br/>Users must complete all islands to unlock the final evaluation. | High | New feature since we moved to mobile app |
| Courses | Training zones to develop specific skill through interactive actions or theoretical questions. | High | New feature since we moved to mobile app  |
| Evaluations | Final step of a module mixing theory and practice questions. Includes a life system to assess progress and motivate users. | High | New feature since we moved to mobile app |
| Profile | Lets users view and update personal information and track their current level. | High | modified to migrate from an OS to a mobile app  |
| Authentication | Allows users to create an EvolOs account or log with OAuth2. Optional for basic use, but required for synchronization progress or trainer tracking. | Medium | modified to migrate from an OS to a mobile app |
| Welcome form | Initial form shown on first launch to adapt content based on the user's skill level: beginner, intermediate, and may be more advanced profile in future versions. | Medium | modified to migrate from an OS to a mobile app  |
| Assistant | Screen helper that introduces app features step-by-step and offers contextual help throughout the user journey. | Medium | modified to migrate from an OS to a mobile app |
| Feedback form | Little question to assess how the user felt during a course. Result are shared with trainers to provide qualitative insights beyond numerical progress. | Low | New feature since we moved to mobile app |
| Awards system | Badge system to encourage progress. Users can view earned and locked achievements. | Low | modified to migrate from an OS to a mobile app |
| App rating prompt | Invite the user to rate Evolos app on the store after completing a module on the roadmap. | Low | New feature since we moved to mobile app |

---

### **2. Beta Testing Scenarios**

### **2.1 User Roles**

| **Role Name** | **Description** |
| --- | --- |
| Regular user (= Learners) | People using the app to improve their digital skills |
|  |  |

### **2.2 Test Scenarios**

### **Scenario 1: *Courses***

- **Role Involved:** *Regular User*
- **Objective:** *Verify that the user can open a course, complete all its steps, receive appropriate error messages and optionally give a feedback at the end.*
- **Preconditions:** *None*
- **Test Steps:**
1. *Open the app and navigate to the roadmap screen.*
2. *Tap on an available (unlocked) course island.*
3. *Try to answer the first step incorrectly.*
4. *Observe the error message, then enter the correct one.*
5. *Repeat the process, with wrong answer or not, until all course steps are completed.*
6. *View the final congratulatory message and the feedback question.*
7. *Choose a rating using the 5 stars system (or skip).*

- **Expected Outcome:**
    - *The course loads correctly.*
    - *The user cannot skip a step without providing the correct answer.*
    - *Helpful error messages are shown on incorrect input.*
    - *A congratulatory message appears at the end of the course.*
    - *The user can rate the course on a 5 stars scale.*
    - *The user is redirected to the roadmap screen, regardless of whether feedback rate was submitted or not.*

### **Scenario 2: Roadmap Island Navigation**

- **Role Involved:** Regular User
- **Objective:** Verify the user can browse islands, distinguish locked/unlocked ones, view descriptions, and access only authorized content.
- **Preconditions:** None
- **Test Steps:**
1. Open the app and access the roadmap screen.
2. Tap on an unlocked (available) island.
3. Verify that the description of the course and it can be launched.
4. Quit, and tap on a locked island.
5. Observe the island description and the message indicating the prerequisite is not met.
- **Expected Outcome:**
  - All islands are visible on the roadmap.
  - Unlocked islands can be accessed and started.
  - Locked islands display their description and a message indicating they are not yet available.
  - The user is redirected to the appropriate island if they try to access a locked one.

### **Scenario 3: Evaluations**

- **Role Involved:** Regular User
- **Objective:** Ensure the evaluation system works properly, including lives, scoring, and retry options.
- **Preconditions:** User has completed all courses necessary to unlock the evaluation.
- **Test Steps:**
1. Click on an unlocked evaluation island.
2. Read the evaluation instructions and start the evaluation.
3. Answer one question correctly.
4. Another question with one mistake and observe the life.
5. Skip one question.
6. Continue until the end.
7. View the final result screen (score + stars).
8. Choose to retry the evaluation.
- **Expected Outcome:** 
  - User sees evaluation rules (e.g number of lives).
  - Each incorrect answer removes a life.
  - The correct answer is reveal if you loose all your lives.
  - You can skip questions.
  - Score and star rating are shown at the end of the evaluation.
  - User can retry the evaluation after finish it.

### **Scenario 4: Profile Page**

- **Role Involved:** Regular User
- **Objective:** Verify that the user can view and edit profile information, and see progression level.
- **Preconditions:** None
- **Test Steps:**
1. Open the app and navigate to the profile page.
2. Check the displayed information: name, email, profile picture.
3. Editing one of the fields (e.g name or email).
4. Observe the update.
5. Observe the progression level.
6. See preferences by clicking on "settings" button.
- **Expected Outcome:** 
  - User can view and update personal information.
  - Changes are saved.
  - The user's progression level is update based on completed modules (e.g if you complete a courses you'll see the 'xp' of the progression level increase).
  - Preferences can be seen by clicking on "settings" but cannot be changed yet. 

### **Scenario 5: Authentication**

- **Role Involved:** Regular User
- **Objective:** Ensure user can log in using email/password or Google, and errors are correctly handled.
- **Preconditions:** None
- **Test Steps:**
1. Try logging in with invalid credentials.
2. Observe the error message. 
3. Log in successfully using correct email/password.
4. Check if the information on the profile match with your information (e.g email address, name....).
- **Expected Outcome:** 
  - Incorrect login attempts show a retry message.
  - Successful login loads correct profile.


### **Scenario 6: Welcome Form**

- **Role Involved:** Regular User
- **Objective:** Verify that the onboarding form collects useful data and assigns an appropriate level.
- **Preconditions:** First launch of the app.
- **Test Steps:**
1. Open the app for the first time.
2. Fill in the welcome form (age, interests, etc.).
3. Answer the self-evaluation and technical test.
4. Submit the form.
5. Observe the assigned user level.
- **Expected Outcome:**
  - Form collects personal and technical data.
  - User level is calculated based on answers.
  - User is attributed appropriate level. (e.g, if you don't know anything you will have "éclaireur" role or "conquérant" if you know all).

### **Scenario 7: Feedback Form**

- **Role Involved:** Regular User
- **Objective:** Check that user can submit feedback after a course and that it is sent to trainers.
- **Preconditions:** User has completed a course.
- **Test Steps:**
1. Complete a course.
2. Rate the course using stars and optionally add a free comment.
3. Submit the feedback.
- **Expected Outcome:**
  - User can give feedback after relevant courses.
  - Rating and comments are recorded and shared with trainers.

### **Scenario 8: Awards system**

- **Role Involved:** Regular User
- **Objective:** Validate badge notifications, earned achievements, and tracking.
- **Preconditions:** User has completed a module with an associated badge.
- **Test Steps:**
1. Complete an evaluation that unlocks a badge.
2. Observe the badge notification popup.
3. Navigate to the award page.
4. Verify the new badge appears as unlocked.
- **Expected Outcome:**
  - Notifications appear upon unlocking.
  - User can see both earned and locked badges.

### **Scenario 9: Assistant**

- **Role Involved:** Regular User
- **Objective:** Ensure the assistant shows contextual help at appropriate times.
- **Preconditions:** 
- **Test Steps:**
1. Access a page for the first time.
2. Observe the assistant’s explanation popup.
- **Expected Outcome:**
  - Assistant shows guidance for new features/pages.

### **Scenario 10: App rating prompt**

- **Role Involved:** Regular User
- **Objective:** Check that user can submit feedback to us.
- **Preconditions:** Complete a module.
- **Test Steps:**
1. Finish all courses and evaluation in a module.
2. Observe the rating prompt.
3. Choose “Rate now” → verify redirection to app store.
- **Expected Outcome:**
  - Prompt appears after module completion.
  - User can choose to rate now, later, or never.
  - Correct redirection or storage of response occurs.

---

### **3. Success Criteria**

To consider this mobile beta phase successful, the following criteria should be met:

- At least 70% of testers have fully completed one module, meaning all its courses and the final evaluation.

- At least 50% of testers have started or completed half of the second module.

- Over 50% response rate to the in-app feedback form, providing valuable insights on course experience and user satisfaction.

- Testers demonstrate an understanding of the course progression, evaluation logic, and overall app structure.

- The application is perceived as a useful tool to develop digital skills by both learners and testers.

- Feedback confirms the system of courses and evaluations provides a structured, engaging, and accessible learning experience.


### **4. Known Issues & Limitations**


| **Issue**                                   | **Description**                                                                                | **Impact** | **Planned Fix? (Yes/No)** |
|---------------------------------------------|------------------------------------------------------------------------------------------------|------------|---------------------------|
| Welcome form | The UX is still not affected by all the result of the welcome form. | High       | Yes                       |
| Modules                          |  advanced modules for "conquérant" and "explorateur" level are not created yet as we don't have any feedback from professionnals   | Medium        | Yes                       |
| Feedback rating system missing              | The 5 stars feedback system shown at the end of a course is not yet  fully implemented.              | Medium     | Yes                       |
| Courses/Evaluation                          | some widgets for the courses/evaluations are still not fully implemented (e.g zooming, screenshots and miscellaneous interaction widgets)    | Medium        | Yes                       |
| Profile page                                | not all preferences set in the settings can affect the UX. (linked with the welcome form issue)    | Low        | Yes                       |
| OAuth with Google                                | not implemented yet    | Low        | Yes                       |


---

## **B - Dashboard Web Interface**

This part concerns the web dashboard design to create and managing courses, tracking learner progress, used by ['trainers'](https://www.notion.so/Beta-Test-Plan-1de8562ccb9080158b49c4772b9ff5e8?pvs=21).

### **1. Core Functionalities for Beta Version**

| **Feature Name**               | **Description**                                              | **Priority (High/Medium/Low)** | **Changes Since Tech3** |
| ------------------------------ | ------------------------------------------------------------ | ------------------------------ | ----------------------- |
| Module creation                | Admin must be able to create module. A module must contain at least 3 courses and exactly 1 evaluation and at list one reward. | High                           |          New feature to complete EvolOs environnement               |
| Course and Evaluation creation | Admin must be able to create a course or an evaluation. They must contain at least 6 steps with clear instructions. | High                           |                       New feature to complete EvolOs environnement  |
| User Progression Tracking      | Trainers must be able to view the learners affiliated with them via a card-based interface displaying essential information (name, competencies). | High                           |          New feature to complete EvolOs environnement               |
| Image uploading                | During course or evaluation creation, trainers should be able to upload images that are stored in the database and displayed within step widgets. | High                           |           New feature to complete EvolOs environnement              |
| Authentication & OAuth2        | Users should be able to log in with an EvolOs account or by using OAuth2 with a google account | Medium                         |              New feature to complete EvolOs environnement           |
| Evaluation creation            | Admin must be able to create an evaluation that tests the skills taught in the module. It must include clear instructions and various types of questions. | High                           |          New feature to complete EvolOs environnement               |
| Users' data tracking           | Admins can access dashboards displaying user progress, completed courses, time spent, and assessment results. Enables performance analysis and follow-ups. | High                           |         New feature to complete EvolOs environnement                |
| Content Visibility             | Allows admins to define the visibility status of a module, a course or an evaluation(e.g Private, Restricted or Public).<br/>Private: content only visible by creator;<br/>Restricted: content visible by internal collaborators;<br/>Public: visible to all learners via the application. | Low                            |            New feature to complete EvolOs environnement             |

---

### **2. Beta Testing Scenarios**

### **2.1 User Roles **

| **Role Name**             | **Description**                                              |
| ------------------------- | ------------------------------------------------------------ |
| Admin                     | Users with full privileges on the dashboard. They can create and manage modules, courses and evaluations. Admins can also track learner progress. This role is typically assigned to someone designated by associations. |
| Regular user (= Trainers) | Trainers cannot create content, only track user progress affiliated to them. |

### **2.2 Test Scenarios**

### **Scenario 1: *Module creation***

**Role Involved:** *Admin*

**Objective:** *Ensure that an admin can create a new module.*

**Preconditions:** *None*

**Test Steps:**

1. *Navigate to the "Modules" section of the dashboard.*
2. *Click on "Create Module" button.*
3. *Fill in the module name field.*
4. *Enter a description explaining the module's purpose and competencies it covers.*
5. *Provide a badge name and upload a corresponding picture.*
6. *Click on the "Save" button.*
7. *Observe the confirmation message and instructions related to course and evaluation requirements.*

**Expected Outcome:**

- *The admin accesses the module creation page successfully.*
- *All required fields are validated (no creation possible if a field is missing).*
- *The badge is uploaded correctly.*
- *After saving, a clear message informs the admin that the module requires at least 3 courses and 1 evaluation to be published.*

### **Scenario 2: *Course creation***

**Role Involved:** *Admin*

**Objective:** *Ensure that an admin can create a new course.*

**Preconditions:** *Created or selected a created module*

**Test Steps:**

1. *Navigate to the "Course" section of the dashboard.*
2. *Click on "Create Course" button.*
3. *Fill in the course name field.*
4. *Enter a description explaining the course's purpose and competencies it covers.*
5. *Enter the approximated duration of the course.*
6. *Provide the instruction of the new course.*
7. *Click on the "Save" button.*
8. *Observe the confirmation message and instructions related to course and evaluation requirements.*

**Expected Outcome:**

- *The admin accesses the course creation page successfully.*
- *All required fields are validated (no creation possible if a field is missing).*
- *After saving, a clear message informs the admin that the course requires at least 6 steps.*

### **Scenario 3: *Evaluation creation***

**Role Involved:** *Admin*

**Objective:** *Ensure that an admin can create a new evaluation.*

**Preconditions:** *Created or selected a created module*

**Test Steps:**

1. Navigate to the "Evaluation" section of the dashboard.
2. Click on the "Create Evaluation" button.
3. Fill in the evaluation name field.
4. Enter a description explaining the purpose and target skills.
5. Add at least 6 steps, each with instructions and expected responses.
6. Save the evaluation.

**Expected Outcome:**

- Admin accesses the evaluation creation interface.
- Fields are validated (name, description, minimum steps).
- Admin receives a confirmation that the evaluation was created successfully.
- Evaluation appears linked to the selected module.

### **Scenario 4: *Users' data tracking***

**Role Involved:** *Regular user*

**Objective:** *Ensure that an user can view and analyze user progress.*

**Preconditions:** *Some users must already have activity history (courses/evaluations completed).*

**Test Steps:**

1. Navigate to the "User Tracking" section of the dashboard.
2. Browse the list of users and select one.
3. View the user's activity summary: completed courses, time spent, and assessment scores.
4. Filter users by progress level or specific modules.
5. See the user's feedback

### **Scenario 5: *Content Visibility***

**Role Involved:** *Admin*

**Objective:** *Ensure that an admin can define and change the visibility of modules, courses, and evaluations.*

**Preconditions:** *Admin has already created a module, course, or evaluation.*

**Test Steps:**

1. Navigate to the dashboard section listing all created content (modules, courses, evaluations).
2. Click on the "Edit" or "Settings" icon next to a module/course/evaluation.
3. Locate the "Visibility" dropdown or selector.
4. Set the visibility to **Private** and save.
5. Repeat the process by setting the visibility to **Restricted**, then to **Public**, each time saving and confirming the change.
6. Log in as another user (trainer or learner) and verify visibility access for each status.

**Expected Outcome:**

- Visibility setting is available and defaults to **Private** when content is created.
- When set to **Private**, only the admin who created the content can see it.
- When set to **Restricted**, internal collaborators can access it but learners cannot.
- When set to **Public**, learners can view the content through the mobile app.
- Changes are saved and take effect immediately.
- Access is correctly enforced depending on the visibility status.

**Expected Outcome:**

- User can view accurate and structured user data.
- Filters and search features work as expected.
- Activity summaries display correct information (number of completed steps, scores, durations, etc.).
- User can use this data for follow-up or reporting.

### **Scenario 6: *Image Uploading***

**Role Involved:** *Admin*

**Objective:** *Ensure that an admin can upload images during course or evaluation creation, and that these images are stored and displayed properly.*

**Preconditions:** *Admin is creating a course or evaluation.*

**Test Steps:**

1. Start creating a new course or evaluation.
2. In one of the steps, click on the "Add Image" button or image upload field.
3. Select an image file from the local computer.
4. Wait for upload confirmation and preview.
5. Complete the rest of the step's data (instruction, expected answer).
6. Save the step and then save the entire course or evaluation.
7. Reopen the created content to verify the image is displayed correctly in the step preview.

**Expected Outcome:**

- Image file is uploaded without errors.
- A preview of the image is shown after upload.
- The image is stored in the backend/database.
- When revisiting the step, the image is visible and linked correctly.



### **Scenario 7: *Authentication and OAuth2***

**Role Involved:** A regular user

**Objective:** *Ensure users can log in with either an EvolOs account (email/password) or using Google OAuth2, and that authentication works correctly across roles.*

**Preconditions:** *User has an existing EvolOs account or Google account.*

**Test Steps:**

1. Navigate to the dashboard login page.
2. Attempt login with invalid email and password.
3. Observe error message.
4. Try again with valid EvolOs account credentials.
5. Log out and repeat the process using the "Sign in with Google" option.
6. Authorize Google OAuth2 access and confirm.
7. After login, verify the user's role and available access.

**Expected Outcome:**

- Login page provides both email/password fields and a Google OAuth2 button.
- Invalid credentials return a clear error message.
- Valid login with EvolOs account redirects to the dashboard with proper permissions.
- Google login opens OAuth window and correctly authenticates the user.
- After login, user data (e.g. name, email) is fetched and role is correctly applied.
- Sessions persist correctly across reloads.



---

### **3. Success Criteria**

The web dashboard beta will be considered successful if:

- Trainers/association members can create modules, courses, and evaluations independently without significant confusion or blocking issues.

- The content creation workflow (modules → courses → evaluations) is clearly understood and used as intended.

- The dashboard successfully displays user progress and activity summaries, and these insights are considered relevant by testers.

- At least some responses are collected via form, email, or oral feedback following the outreach campaign to 20 partner associations.

---

### **4. Known Issues & Limitations**

| **Issue**                                  | **Description**                                              | **Impact** | **Planned Fix? (Yes/No)** |
| ------------------------------------------ | ------------------------------------------------------------ | ---------- | ------------------------- |
| Badges not implemented                     | Each module should have at least one badge                   | Medium     | Yes                       |
| Content Visibility feature not implemented | The admin should be able to change the visibility of a course (Public, private, etc) | High       | Yes                       |
| Authentification & OAuth2 not implemented  | Every user should be able to register or to login by using regular login or OAuth2 | High       | Yes                       |

---

## **5. Conclusion**

This Beta Test Plan aims to validate the core foundations of EvolOs, across both its mobile application and web dashboard. The goal is to demonstrate the real-life usability of our platform in helping learners acquire essential digital skills, while giving trainers the tools to create, manage, and track training paths.

By gathering feedback from early testers, we aim to:

  - Identify critical bugs or usability issues,

  - Validate key features and user flows,

- Showcase EvolOs' maturity to potential partners and supporters.
