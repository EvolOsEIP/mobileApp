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
| Roadmap Island | Main screen inspired by Duolingo's roadmap where each "island" represents a course or an evaluation.<br/>Users must complete all islands to unlock the final evaluation. | High | Improvement of UI design inspired from Duolingo's roadmap to improve user experience |
| Courses | Training zones to develop specific skill through interactive actions or theoretical questions. | High |  |
| Evaluations | Final step of a module mixing theory and practice questions. Includes a life system to assess progress and motivate users. | High |  |
| Profile | Lets users view and update personal information and track their current level. | High |  |
| Authentication | Allows users to create an EvolOs account or log with OAuth2. Optional for basic use, but required for synchronization progress or trainer tracking. | Medium | [Modifications or additions] |
| Welcome form | Initial form shown on first launch to adapt content based on the user's skill level: beginner, intermediate, and may be more advanced profile in future versions. | Medium |  |
| Feedback form | Little question to assess how the user felt during a course. Result are shared with trainers to provide qualitative insights beyond numerical progress. | Low |  |
| Awards system | Badge system to encourage progress. Users can view earned and locked achievements. | Low |  |
| Assistant | Screen helper that introduces app features step-by-step and offers contextual help throughout the user journey. | Low |  |
| App rating prompt | Invite the user to rate Evolos app on the store after completing a module on the roadmap. | Low |  |

---

### **2. Beta Testing Scenarios**

### **2.1 User Roles**

| **Role Name** | **Description** |
| --- | --- |
| Regular user (= Learners) | People using the app to improve their digital skills |
|  |  |

### **2.2 Test Scenarios**

### **Scenario 1: *Courses***

**Role Involved:** *Regular User***Objective:** *Verify that the user can open a course, complete all its steps, receive appropriate error messages and optionally give a feedback at the end.***Preconditions:** *None***Test Steps:**

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
- **Expected Outcome:** 
  - User can view and update personal information.
  - Changes are saved.
  - The user's progression level is update based on completed modules (e.g if you complete a courses you'll see the 'xp' of the progression level increase).

### **Scenario 5: Authentication**

- **Role Involved:** Regular User
- **Objective:** Ensure user can log in using email/password or Google, and errors are correctly handled.
- **Preconditions:** None
- **Test Steps:**
    1. Try logging in with invalid credentials.
    2. Observe the error message. 
    3. Log in successfully using correct email/password or Google.
    4. Check if the information on the profile match with the information of your email or Google account.
- **Expected Outcome:** 
  - Incorrect login attempts show a retry message.
  - Successful login loads correct profile.
  - OAuth (Google) login works if selected


### **Scenario X: [Feature Name]**

- **Role Involved:** [e.g., Regular User]
- **Objective:** [What is being tested?]
- **Preconditions:** [Any required setup before running the test]
- **Test Steps:**
    1. [Step 1]
    2. [Step 2]
    3. [Step 3]
- **Expected Outcome:** [What should happen if the feature works correctly?]


---

### **3. Success Criteria**

[Define the metrics and conditions that determine if the beta version is successful.]

People likes to spend time on our application,
Partners / trainers judged helpful and recommend the use of our application for the digital illiteracy.

### **4. Known Issues & Limitations**

[List any known bugs, incomplete features, or limitations that testers should be aware of.]

| **Issue** | **Description** | **Impact** | **Planned Fix? (Yes/No)** |
| --- | --- | --- | --- |
| Course and Evaluation status not functional | The logic for determining whether a course or evaluation is accessible is not yet implemented. | High | Yes |
| Feedback rating system missing | The 5 stars feedback systeme shown at the end of a course is not yet implemented. | Medium | Yes |

---

## **B - Dashboard Web Interface**

This part concerns the web dashboard design to create and managing courses, tracking learner progress, used by ['trainers'](https://www.notion.so/Beta-Test-Plan-1de8562ccb9080158b49c4772b9ff5e8?pvs=21).

### **1. Core Functionalities for Beta Version**

| **Feature Name** | **Description** | **Priority (High/Medium/Low)** | **Changes Since Tech3** |
| --- | --- | --- | --- |
| Module creation | Admin must be able to create module. A module must contain at least 3 courses and exactly 1 evaluation and at list one reward. | High | this feature is on its first version as the admin interface has just been introduced to Evolos project. |
| Course and Evaluation creation | Admin must be able to create a course or an evaluation. They must contain at least 6 steps with clear instructions. | High |  |
| User Progression Tracking | Trainers must be able to view the learners affiliated with them via a card-based interface displaying essential information (name, competencies). | High |  |
| Image uploading | During course or evaluation creation, trainers should be able to upload images that are stored in the database and displayed within step widgets. | High |  |
| Authentication & OAuth2 | Users should be able to log in with an EvolOs account or by using OAuth2 with a google account | Medium |  |
| Content Visibility | Allows admins to define the visibility status of a module, a course or an evaluation(e.g Private, Restricted or Public).<br/>Private: content only visible by creator;<br/>Restricted: content visible by internal collaborators;<br/>Public: visible to all learners via the application. | Low |  |

---

### **2. Beta Testing Scenarios**

### *2.1 User Roles **

| **Role Name** | **Description** |
| --- | --- |
| Admin | Users with full privileges on the dashboard. They can create and manage modules, courses and evaluations. Admins can also track learner progress. This role is typically assigned to someone designated by associations. |
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

### **Scenario X: [Feature Name]**

- **Role Involved:** [e.g., Regular User]
    - **Objective:** [What is being tested?]
    - **Preconditions:** [Any required setup before running the test]
    - **Test Steps:**
        1. [Step 1]
        2. [Step 2]
        3. [Step 3]
    - **Expected Outcome:** [What should happen if the feature works correctly?]

---

### **3. Success Criteria**

---

### **4. Known Issues & Limitations**

| **Issue** | **Description** | **Impact** | **Planned Fix? (Yes/No)** |
| --- | --- | --- | --- |
| Badges not implemented | Each module should have at least one badge | Medium | Yes |
| Fields not checked | Not checking if all fields are filled | High | Yes |

---

---

## **5. Conclusion**

[Summarize the importance of this Beta Test Plan and what the team expects to achieve with it.]