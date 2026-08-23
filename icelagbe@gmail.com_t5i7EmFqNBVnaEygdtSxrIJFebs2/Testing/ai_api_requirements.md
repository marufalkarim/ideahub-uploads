# AI API Requirements for IdeaHub

To transition IdeaHub from a frontend prototype to a fully functional platform with real AI capabilities, you will need a combination of Large Language Model (LLM) APIs, Vector Database APIs for semantic search, and general backend infrastructure.

Here is the comprehensive list of APIs you will need to fully implement the mocked AI features:

## 1. The Core LLM Provider (The "Brain")
You will need a powerful LLM to handle the reasoning tasks (architecture generation, scope analysis, and the conversational chatbot). 

**Recommended APIs:**
*   **OpenAI API (GPT-4o or GPT-4o-mini)**
    *   **Why:** Currently the industry standard for reasoning, generating structured JSON data (like tech stacks and schemas), and powering conversational agents.
*   **Anthropic API (Claude 3.5 Sonnet)**
    *   **Why:** Excellent at coding architecture, technical writing, and following complex multi-step prompts. Often outperforms others in strict technical analysis.
*   **Google Gemini API (Gemini 1.5 Pro)**
    *   **Why:** Has a massive context window, useful if you want the AI to analyze huge codebases or long, complex project specifications.

**Implementation Areas:**
*   **Auto-Generated Technical Architecture:** Prompt the LLM with the user's project idea and ask it to output a JSON schema representing the recommended tech stack and database design.
*   **Scope & Feasibility Scorer:** Prompt the LLM to analyze the idea against the user's chosen timeline (e.g., "1-2 weeks") and return warnings if the scope is too large.
*   **Floating AI Chatbot:** Use the API's chat completion endpoints to hold a continuous conversation with the user, maintaining the context of what page they are currently viewing.

---

## 2. Vector Database & Embedding API (For "Smart Duplicate Detection")
To detect if a user's new project idea is a duplicate of an existing project, standard keyword search isn't enough. You need **Semantic Search**.

**How it works:**
You convert every project's description into a mathematical vector (an "embedding"). When a user submits a new idea, you convert their idea into an embedding and use a Vector Database to find mathematically similar projects in real-time.

**Required APIs:**
*   **Embedding API (to convert text to vectors):**
    *   OpenAI `text-embedding-3-small` or `text-embedding-3-large`
    *   Cohere Embed API
*   **Vector Database (to store and search vectors):**
    *   **Pinecone API:** Fully managed, very fast, easy to integrate.
    *   **Supabase (pgvector):** If you are using Supabase as your main database, you can use its built-in vector search capabilities.
    *   **Weaviate / Qdrant:** Open-source alternatives with cloud APIs.

---

## 3. GitHub / GitLab APIs (For "Auto Repo Generator")
While not strictly an "AI" feature, the AI Architecture generator pairs directly with the button that says "Generate Repo". To make that button work:

**Required APIs:**
*   **GitHub REST API / GraphQL API:** 
    *   Use the `POST /user/repos` endpoint to create a new repository on the user's behalf (requires OAuth).
    *   Use the Trees/Commits API to automatically inject the AI-generated `README.md` and boilerplate code directly into the new repository.

---

## 4. Backend Orchestration (Optional but Recommended)
To prevent your API keys (like your OpenAI key) from being exposed in your frontend HTML/JS code, you *must* route these AI requests through a backend server.

**Recommended Services:**
*   **Vercel / Netlify Serverless Functions:** Easy way to create lightweight API endpoints (`/api/generate-architecture`) that securely hold your OpenAI keys and communicate with your frontend.
*   **Supabase Edge Functions / Firebase Cloud Functions:** Great if you are already using them for your user database and authentication.
*   **LangChain / LlamaIndex (Frameworks, not APIs):** If you build a Node.js or Python backend, use these libraries to easily chain together the Vector DB searches and the LLM prompts.

## Summary Architecture Flow
1. User clicks "Generate Architecture" on the frontend.
2. Frontend sends the project description to your **Serverless Backend**.
3. Backend calls **OpenAI Embeddings API** and queries **Pinecone** to check for duplicates.
4. Backend calls **Anthropic/OpenAI API** to generate the architecture and scope warning.
5. Backend returns the formatted JSON payload to the frontend.
6. Frontend updates the UI (removes loading spinner, shows results).
