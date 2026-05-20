-- Enable RLS
-- Profiles table
CREATE TABLE public.profiles (
  id UUID REFERENCES auth.users ON DELETE CASCADE PRIMARY KEY,
  full_name TEXT,
  avatar_url TEXT,
  role TEXT DEFAULT 'patient' CHECK (role IN ('patient', 'doctor', 'admin')),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Patients table (EHR)
CREATE TABLE public.patients (
  id UUID REFERENCES public.profiles(id) ON DELETE CASCADE PRIMARY KEY,
  date_of_birth DATE,
  gender TEXT,
  blood_type TEXT,
  medical_history JSONB DEFAULT '{}',
  emergency_contact JSONB DEFAULT '{}',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Medical Records
CREATE TABLE public.medical_records (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  patient_id UUID REFERENCES public.patients(id) ON DELETE CASCADE NOT NULL,
  doctor_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  record_type TEXT NOT NULL, -- screening, surgery, prescription
  data JSONB DEFAULT '{}',
  image_urls TEXT[] DEFAULT '{}',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Eye Tests
CREATE TABLE public.eye_tests (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  patient_id UUID REFERENCES public.patients(id) ON DELETE CASCADE NOT NULL,
  test_type TEXT NOT NULL, -- acuity, amsler, contrast
  results JSONB DEFAULT '{}',
  vision_score FLOAT,
  eye TEXT CHECK (eye IN ('left', 'right', 'both')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS on all tables
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.patients ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.medical_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.eye_tests ENABLE ROW LEVEL SECURITY;

-- Policies

-- Profiles: Users can view all profiles (for search/community) but only update their own
CREATE POLICY "Public profiles are viewable by everyone" ON public.profiles
  FOR SELECT USING (true);

CREATE POLICY "Users can insert their own profile" ON public.profiles
  FOR INSERT WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON public.profiles
  FOR UPDATE USING (auth.uid() = id);

-- Patients: Only the user (patient) or an authorized doctor can view/update
CREATE POLICY "Users can view own patient data" ON public.patients
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own patient data" ON public.patients
  FOR UPDATE USING (auth.uid() = id);

-- Medical Records: Only patient or doctor can view
CREATE POLICY "Patients and Doctors can view records" ON public.medical_records
  FOR SELECT USING (
    auth.uid() = patient_id OR 
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'doctor')
  );

-- Eye Tests: Only patient or doctor can view
CREATE POLICY "Patients and Doctors can view eye tests" ON public.eye_tests
  FOR SELECT USING (
    auth.uid() = patient_id OR 
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'doctor')
  );

-- Trigger for creating profile on auth signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name, avatar_url)
  VALUES (new.id, new.raw_user_meta_data->>'full_name', new.raw_user_meta_data->>'avatar_url');
  
  -- If user is a patient (default), also create patient entry
  INSERT INTO public.patients (id)
  VALUES (new.id);
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();
