-- Telemedicine Schema

-- Doctor Profiles (Extension of basic profiles)
CREATE TABLE public.doctors (
  id UUID REFERENCES public.profiles(id) ON DELETE CASCADE PRIMARY KEY,
  specialization TEXT NOT NULL,
  hospital_affiliation TEXT,
  license_number TEXT UNIQUE,
  bio TEXT,
  rating FLOAT DEFAULT 5.0,
  consultation_fee DECIMAL(10, 2),
  is_available BOOLEAN DEFAULT true,
  available_hours JSONB DEFAULT '[]', -- e.g., [{"day": "Monday", "slots": ["09:00", "10:00"]}]
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Appointments
CREATE TABLE public.appointments (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  patient_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  doctor_id UUID REFERENCES public.doctors(id) ON DELETE CASCADE NOT NULL,
  appointment_date TIMESTAMP WITH TIME ZONE NOT NULL,
  status TEXT DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'completed', 'cancelled', 'in-progress')),
  meeting_link TEXT, -- WebRTC or Jitsi link
  notes TEXT,
  prescription_id UUID, -- Link to a future prescriptions table
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.doctors ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.appointments ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Doctor profiles are public" ON public.doctors FOR SELECT USING (true);

CREATE POLICY "Patients can view own appointments" ON public.appointments
  FOR SELECT USING (auth.uid() = patient_id);

CREATE POLICY "Doctors can view assigned appointments" ON public.appointments
  FOR SELECT USING (auth.uid() = doctor_id);

CREATE POLICY "Patients can book appointments" ON public.appointments
  FOR INSERT WITH CHECK (auth.uid() = patient_id);

-- Insert some dummy doctor data for testing
-- (Assuming some users exist or will be created)
