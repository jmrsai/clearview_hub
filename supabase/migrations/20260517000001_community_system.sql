-- Community System Schema

-- Communities (Groups)
CREATE TABLE public.communities (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  description TEXT,
  slug TEXT NOT NULL UNIQUE, -- e.g., 'glaucoma-support'
  icon_url TEXT,
  banner_url TEXT,
  category TEXT DEFAULT 'general', -- clinical, lifestyle, research
  member_count INT DEFAULT 0,
  is_verified BOOLEAN DEFAULT false, -- verified by doctors
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Community Posts
CREATE TABLE public.community_posts (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  community_id UUID REFERENCES public.communities(id) ON DELETE CASCADE NOT NULL,
  author_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  image_urls TEXT[] DEFAULT '{}',
  is_anonymous BOOLEAN DEFAULT false,
  upvotes INT DEFAULT 0,
  downvotes INT DEFAULT 0,
  comment_count INT DEFAULT 0,
  tags TEXT[] DEFAULT '{}',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Community Comments
CREATE TABLE public.community_comments (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  post_id UUID REFERENCES public.community_posts(id) ON DELETE CASCADE NOT NULL,
  author_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  parent_id UUID REFERENCES public.community_comments(id) ON DELETE CASCADE, -- For nested threads
  content TEXT NOT NULL,
  is_anonymous BOOLEAN DEFAULT false,
  upvotes INT DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Community Reactions (Upvotes/Downvotes)
CREATE TABLE public.community_reactions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  post_id UUID REFERENCES public.community_posts(id) ON DELETE CASCADE,
  comment_id UUID REFERENCES public.community_comments(id) ON DELETE CASCADE,
  reaction_type TEXT CHECK (reaction_type IN ('upvote', 'downvote', 'helpful', 'care')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, post_id),
  UNIQUE(user_id, comment_id)
);

-- Community Memberships
CREATE TABLE public.community_members (
  community_id UUID REFERENCES public.communities(id) ON DELETE CASCADE NOT NULL,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  role TEXT DEFAULT 'member' CHECK (role IN ('member', 'moderator', 'admin')),
  joined_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  PRIMARY KEY (community_id, user_id)
);

-- Enable RLS
ALTER TABLE public.communities ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.community_posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.community_comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.community_reactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.community_members ENABLE ROW LEVEL SECURITY;

-- Policies

-- Communities are viewable by everyone
CREATE POLICY "Communities are public" ON public.communities FOR SELECT USING (true);

-- Posts are viewable by everyone
CREATE POLICY "Posts are public" ON public.community_posts FOR SELECT USING (true);

-- Users can create posts if they are authenticated
CREATE POLICY "Authenticated users can create posts" ON public.community_posts
  FOR INSERT WITH CHECK (auth.uid() IS NOT NULL);

-- Only author can update/delete their post
CREATE POLICY "Authors can manage their posts" ON public.community_posts
  FOR ALL USING (auth.uid() = author_id);

-- Comments are public
CREATE POLICY "Comments are public" ON public.community_comments FOR SELECT USING (true);

-- Reactions: Users can only manage their own
CREATE POLICY "Users can manage own reactions" ON public.community_reactions
  FOR ALL USING (auth.uid() = user_id);

-- Functions & Triggers to update counts

-- Increment post comment count
CREATE OR REPLACE FUNCTION public.handle_new_comment()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE public.community_posts
  SET comment_count = comment_count + 1
  WHERE id = NEW.post_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_comment_created
  AFTER INSERT ON public.community_comments
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_comment();

-- Auto-slugify community names (Simplified)
CREATE OR REPLACE FUNCTION public.slugify_community()
RETURNS TRIGGER AS $$
BEGIN
  NEW.slug := lower(replace(NEW.name, ' ', '-'));
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_community_created_slug
  BEFORE INSERT ON public.communities
  FOR EACH ROW EXECUTE PROCEDURE public.slugify_community();
