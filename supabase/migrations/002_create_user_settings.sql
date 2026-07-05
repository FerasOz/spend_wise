-- Step 2: user settings table for app preferences
create table if not exists public.user_settings (
  user_id uuid primary key references auth.users(id) on delete cascade,
  theme_mode text not null default 'system',
  currency_code text not null default 'USD',
  language text not null default 'english',
  updated_at timestamptz not null default now()
);

alter table public.user_settings enable row level security;

create policy "Users can view own settings"
  on public.user_settings
  for select
  using (auth.uid() = user_id);

create policy "Users can insert own settings"
  on public.user_settings
  for insert
  with check (auth.uid() = user_id);

create policy "Users can update own settings"
  on public.user_settings
  for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
