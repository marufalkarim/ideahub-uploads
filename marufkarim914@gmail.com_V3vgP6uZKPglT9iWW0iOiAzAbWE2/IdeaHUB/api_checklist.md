# IdeaHub API Implementation Checklist

Here is a streamlined, actionable checklist of the APIs you will need to register for, along with the links to find them.

## 1. Large Language Model (LLM) API 
*Choose ONE of the following to act as the "brain" for the chatbot, architecture generator, and scope scorer.*

- [ ] **OpenAI API (GPT-4o)**
  - **Best for:** Overall reasoning, structured JSON output, widespread community support.
  - **Where to find it:** [platform.openai.com](https://platform.openai.com/)
  
- [ ] **Anthropic API (Claude 3.5 Sonnet)**
  - **Best for:** Technical coding tasks, architecture planning, and nuanced conversational tone.
  - **Where to find it:** [console.anthropic.com](https://console.anthropic.com/)

- [ ] **Google Gemini API**
  - **Best for:** Extremely large context windows (processing huge project specs at once).
  - **Where to find it:** [aistudio.google.com](https://aistudio.google.com/)

---

## 2. Vector Database & Embeddings (For Duplicate Detection)
*You need an Embeddings API to turn project descriptions into math, and a Vector DB to search through them.*

- [ ] **Embeddings API (OpenAI or Cohere)**
  - **Where to find it:** Included in your [OpenAI account](https://platform.openai.com/), or at [cohere.com](https://cohere.com/)
  
- [ ] **Pinecone (Vector Database)**
  - **Best for:** Extremely fast, fully-managed cloud vector search.
  - **Where to find it:** [pinecone.io](https://www.pinecone.io/)
  
- [ ] **Supabase pgvector (Alternative Vector Database)**
  - **Best for:** If you also need a traditional database (PostgreSQL) and user authentication all in one place.
  - **Where to find it:** [supabase.com](https://supabase.com/)

---

## 3. GitHub Integrations
*Required to power the "Generate Repo" functionality.*

- [ ] **GitHub REST / GraphQL API**
  - **Best for:** Programmatically creating repositories, injecting code, and managing issues.
  - **Where to find it:** [docs.github.com/en/rest](https://docs.github.com/en/rest) (You will need to create a GitHub OAuth App or Personal Access Token in your developer settings).

---

## 4. Backend / Orchestration 
*You cannot put API keys directly in your HTML/JS files for security. You must hide them in a backend service.*

- [ ] **Vercel Serverless Functions**
  - **Best for:** Easiest way to spin up secure API endpoints (like `/api/chat`) using Node.js or Python to hide your OpenAI keys.
  - **Where to find it:** [vercel.com](https://vercel.com/)

---

## 5. User Authentication & Database (Storing Credentials)
*To securely store user passwords, handle OAuth (Google/GitHub login), and manage user sessions, you should use an Auth-as-a-Service or Backend-as-a-Service (BaaS) provider rather than building it from scratch.*

- [ ] **Supabase (Auth + Database)**
  - **Best for:** The most comprehensive open-source alternative to Firebase. It gives you a PostgreSQL database, extremely easy Authentication (Email/Password, GitHub, Google), and even vector storage (pgvector) all in one place.
  - **Where to find it:** [supabase.com](https://supabase.com/)

- [ ] **Clerk (Auth Only)**
  - **Best for:** Drop-in, beautiful, and highly secure authentication components (Login, Signup, User Profile widgets) that are incredibly easy to integrate with frontend frameworks.
  - **Where to find it:** [clerk.com](https://clerk.com/)

- [ ] **Auth0 (by Okta)**
  - **Best for:** Enterprise-grade security and highly complex identity management. (A bit heavier than Clerk/Supabase, but the industry standard).
  - **Where to find it:** [auth0.com](https://auth0.com/)

- [ ] **Firebase Authentication**
  - **Best for:** Quick, robust integration backed by Google. It pairs well if you decide to use Firestore as your NoSQL database instead of a relational SQL database.
  - **Where to find it:** [firebase.google.com](https://firebase.google.com/)
