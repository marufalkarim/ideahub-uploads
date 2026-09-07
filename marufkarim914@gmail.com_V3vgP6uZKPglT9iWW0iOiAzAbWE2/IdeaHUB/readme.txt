============================================================
IdeaHub - Frontend Prototype Overview & Code Architecture
============================================================

1. PROJECT OVERVIEW
------------------------------------------------------------
IdeaHub is a high-performance, responsive frontend prototype designed for project discovery, idea submission, and team formation. The architecture utilizes a "vanilla" Single Page Application (SPA) approach using just HTML, CSS, and plain JavaScript, meaning it dynamically loads and renders content without a backend framework (like React or Angular) and without refreshing the browser page.


2. TECHNOLOGY STACK
------------------------------------------------------------
* HTML5: Semantic structure and layout.
* CSS3: Custom styling, CSS Variables for theming (Dark Mode with Indigo/Emerald accents), Flexbox/Grid for layout, and Glassmorphism effects (backdrop-filter).
* JavaScript (ES6+): Client-side routing, DOM manipulation, state management, and interactive UI logic.
* Boxicons & Google Fonts: Used for iconography and typography (Inter & Outfit).


3. DIRECTORY STRUCTURE
------------------------------------------------------------
/
|-- index.html                 (Main entry point containing the shell layout)
|-- styles/
|   |-- main.css               (Global styles, animations, variables, and themes)
|-- js/
    |-- data.js                (Mock JSON data acting as the local database)
    |-- app.js                 (Core SPA router, global event listeners)
    |-- modules/               (Component logic separated by view)
        |-- discovery.js       (Logic for the search & discover page)
        |-- submission.js      (Logic for the project submission wizard)
        |-- projectDetails.js  (Logic for the specific project specification view)
        |-- dashboard.js       (Logic for the admin dashboard)


4. HOW THE CODE WORKS (THE MECHANISM)
------------------------------------------------------------

A. The "Shell" (index.html)
The `index.html` file acts as the app shell. It contains static elements that are always visible across the application, such as:
- The Sidebar Navigation (left)
- The Topbar with the search bar, notification bell, and "New Project" button
- The Chatbot floating widget
- An empty `<div id="app-root"></div>` container. This is the most important part of the HTML; it is where the JavaScript dynamically injects different "pages".

B. The Router & Global Logic (js/app.js)
When the page loads, `app.js` initializes the `App` class. 
1. It registers the various modules (Discovery, Submission, etc.).
2. It attaches click listeners to the navigation links. 
3. When a user clicks a nav link, `e.preventDefault()` stops the browser from actually going to a new URL. Instead, it calls the `navigate(viewName)` method.
4. The `navigate` method finds the `<div id="app-root"></div>`, clears its current HTML contents, and calls the `render()` method of the requested module. It then injects the returned HTML string into the DOM.
5. This file also contains global UI event listeners, such as the `Ctrl+K` keyboard shortcut for focusing the search bar, the notification dropdown toggle, and the floating AI chatbot logic.

C. The Data Layer (js/data.js)
Because there is no real backend server, `data.js` exposes a global constant `window.MOCK_DATA`. This object acts like a database payload, containing arrays of dummy users, projects, and tag filters. The modules read from this object to populate their lists and cards.

D. The Modules (js/modules/*.js)
Each view is abstracted into its own JavaScript Class. 
For example, `DiscoveryModule` (in discovery.js) has a `render()` method that:
- Reads the projects from `MOCK_DATA`.
- Uses JavaScript Template Literals (`...`) to loop over the projects and construct HTML strings for each project card.
- Injects a `<style>` tag into the document head (if it doesn't already exist) that contains CSS specific only to that module.
- Returns the full HTML string to the App router to be displayed on screen.
Other modules like `SubmissionModule` or `ProjectDetailsModule` work similarly, but they also use JavaScript `setTimeout()` to mock server delays (like simulating an AI generation delay or a GitHub Repo creation delay).

E. The Styling (styles/main.css)
The CSS file relies heavily on CSS Variables (`:root`) to maintain a consistent color palette. The UI achieves its premium look using "Glassmorphism," which is done by giving panels a semi-transparent background color (`rgba`) combined with a `backdrop-filter: blur(12px)`. The layout relies on CSS Grid (for complex 2-column dashboards) and Flexbox (for alignments and navigation).


5. SUMMARY FOR PRESENTATION
------------------------------------------------------------
If you are explaining this code, you can summarize it simply as:
"This is a custom-built Vanilla JavaScript Single Page Application (SPA). The `index.html` provides a static shell, while `app.js` acts as a router that intercepts clicks and dynamically swaps out the inner HTML of the main container. We broke down each 'page' into modular JavaScript classes to keep the code organized, and we use a central `data.js` file to simulate database API responses."
