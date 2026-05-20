-- Global Ecosystem Platform Schema

-- 1. Knowledge System (Verified Medical Articles)
CREATE TABLE public.medical_articles (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,
  content TEXT NOT NULL,
  summary TEXT,
  author_id UUID REFERENCES public.profiles(id), -- Nullable if imported from external source
  source_organization TEXT, -- e.g., 'WHO', 'NIH', 'Mayo Clinic'
  source_url TEXT,
  category TEXT CHECK (category IN ('disease', 'treatment', 'prevention', 'anatomy', 'glossary')),
  tags TEXT[] DEFAULT '{}',
  is_verified BOOLEAN DEFAULT true, -- Only verified content allowed
  verified_by_doctor_id UUID REFERENCES public.doctors(id),
  language_code TEXT DEFAULT 'en',
  view_count INT DEFAULT 0,
  published_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Video Learning Platform
CREATE TABLE public.medical_videos (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  video_url TEXT NOT NULL, -- HLS/DASH streaming URL
  thumbnail_url TEXT,
  duration_seconds INT,
  category TEXT CHECK (category IN ('surgery', 'exercise', 'education', 'rehabilitation', '3d_animation')),
  author_id UUID REFERENCES public.profiles(id),
  source_organization TEXT,
  is_verified BOOLEAN DEFAULT true,
  language_code TEXT DEFAULT 'en',
  subtitles_available TEXT[] DEFAULT '{"en"}',
  view_count INT DEFAULT 0,
  published_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. Entrepreneur & Business Ecosystem (Clinics, Startups)
CREATE TABLE public.businesses (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  owner_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  business_name TEXT NOT NULL,
  business_type TEXT CHECK (business_type IN ('clinic', 'startup', 'optical_store', 'ngo', 'research_lab')),
  description TEXT,
  contact_email TEXT,
  contact_phone TEXT,
  website_url TEXT,
  address JSONB, -- {"street": "", "city": "", "country": "", "coordinates": {"lat": 0, "lng": 0}}
  verification_status TEXT DEFAULT 'pending' CHECK (verification_status IN ('pending', 'verified', 'rejected')),
  subscription_tier TEXT DEFAULT 'free' CHECK (subscription_tier IN ('free', 'pro', 'enterprise')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. 3D Education Models Directory
CREATE TABLE public.educational_3d_models (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  model_url TEXT NOT NULL, -- URL to GLTF/GLB or Unity AssetBundle
  complexity_level TEXT DEFAULT 'beginner' CHECK (complexity_level IN ('beginner', 'student', 'professional')),
  anatomy_part TEXT, -- e.g., 'retina', 'cornea', 'optic_nerve'
  interactive_labels JSONB DEFAULT '[]', -- JSON array of labels and coordinates
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.medical_articles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.medical_videos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.businesses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.educational_3d_models ENABLE ROW LEVEL SECURITY;

-- Policies (Public Read, Restrictive Write)
CREATE POLICY "Medical articles are public" ON public.medical_articles FOR SELECT USING (true);
CREATE POLICY "Medical videos are public" ON public.medical_videos FOR SELECT USING (true);
CREATE POLICY "Verified businesses are public" ON public.businesses FOR SELECT USING (verification_status = 'verified' OR auth.uid() = owner_id);
CREATE POLICY "3D Models are public" ON public.educational_3d_models FOR SELECT USING (true);

-- Business Owners can manage their businesses
CREATE POLICY "Business owners can update their business" ON public.businesses
  FOR UPDATE USING (auth.uid() = owner_id);
CREATE POLICY "Business owners can create businesses" ON public.businesses
  FOR INSERT WITH CHECK (auth.uid() = owner_id);
