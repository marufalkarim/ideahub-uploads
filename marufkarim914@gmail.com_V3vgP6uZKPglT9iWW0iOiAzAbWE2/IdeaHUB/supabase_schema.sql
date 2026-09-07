-- ========================================================
-- IDEAHUB SUPABASE SCHEMA
-- Copy and paste this entirely into the Supabase SQL Editor
-- ========================================================

-- 1. Create a table for public Profiles
CREATE TABLE public.profiles (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    name TEXT,
    avatar TEXT,
    role TEXT DEFAULT 'user'::text,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW())
);

-- Turn on Row Level Security for profiles
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Allow public read access to profiles
CREATE POLICY "Public profiles are viewable by everyone." 
ON public.profiles FOR SELECT USING (true);

-- Allow users to update their own profile
CREATE POLICY "Users can insert their own profile." 
ON public.profiles FOR INSERT WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can update own profile." 
ON public.profiles FOR UPDATE USING (auth.uid() = id);


-- 2. Trigger to automatically create a profile on Signup
CREATE OR REPLACE FUNCTION public.handle_new_user() 
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, name, avatar, role)
  VALUES (
    new.id, 
    COALESCE(new.raw_user_meta_data->>'full_name', 'New User'), 
    COALESCE(new.raw_user_meta_data->>'avatar_url', 'https://ui-avatars.com/api/?name=User'),
    'user'
  );
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();


-- 3. Create the Projects table
CREATE TABLE public.projects (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    title TEXT NOT NULL,
    domain TEXT NOT NULL,
    duration TEXT NOT NULL,
    description TEXT NOT NULL,
    solution TEXT NOT NULL,
    status TEXT DEFAULT 'Pending'::text, -- Pending, Active, Rejected
    skills TEXT[] DEFAULT '{}',
    upvotes INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW())
);

-- Turn on Row Level Security for projects
ALTER TABLE public.projects ENABLE ROW LEVEL SECURITY;

-- Allow anyone to read Active/Approved projects
CREATE POLICY "Anyone can view Active projects" 
ON public.projects FOR SELECT USING (status = 'Active');

-- Allow admins to read all projects (Pending, Rejected, Active)
CREATE POLICY "Admins can view all projects" 
ON public.projects FOR SELECT USING (
  EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
);

-- Allow users to read their own projects, regardless of status
CREATE POLICY "Users can view own projects" 
ON public.projects FOR SELECT USING (auth.uid() = user_id);

-- Allow authenticated users to insert projects
CREATE POLICY "Authenticated users can insert projects" 
ON public.projects FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Allow users to update their own projects
CREATE POLICY "Users can update own projects" 
ON public.projects FOR UPDATE USING (auth.uid() = user_id);

-- Allow admins to update any project (e.g. change status)
CREATE POLICY "Admins can update any project" 
ON public.projects FOR UPDATE USING (
  EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'admin')
);


-- 4. Initial Dummy Data (Optional: creates an admin user if you have an auth user already)
-- Note: It is best to sign up normally first via the frontend, then manually 
-- change your role to 'admin' in the Table Editor to access the dashboard.
