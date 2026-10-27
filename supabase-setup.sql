-- Run once in Supabase: SQL Editor > New query > paste > Run
create table if not exists public.appointments (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  first_name text not null check (char_length(first_name) <= 80),
  last_name text not null check (char_length(last_name) <= 80),
  email text not null check (char_length(email) <= 160),
  phone text not null check (char_length(phone) <= 40),
  patient_type text check (patient_type in ('New', 'Existing')),
  treatments text check (char_length(treatments) <= 300),
  appointment_date date,
  appointment_time text check (char_length(appointment_time) <= 20),
  location text default '1006 Bay Street',
  status text not null default 'Pending'
);

alter table public.appointments enable row level security;

grant usage on schema public to anon;
grant insert on public.appointments to anon;

-- Visitors can only ADD requests. Nobody can read them with the public key.
drop policy if exists "Visitors can submit appointment requests" on public.appointments;
create policy "Visitors can submit appointment requests"
  on public.appointments for insert to anon
  with check (true);
