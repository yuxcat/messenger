 
-- Create a table for public "profiles"
create table messages (
  id uuid references auth.users not null,
  updated_at timestamp with time zone,
  msg text ARRAY,

  primary key (id)
);

alter table messages enable row level security;

create policy "Public messages are viewable by everyone."
  on messages for select
  using ( true );

create policy "Users can insert their own messages."
  on messages for insert
  with check ( auth.uid() = id );

-- Set up Realtime!
begin;
  drop publication if exists supabase_realtime;
  create publication supabase_realtime;
commit;
alter publication supabase_realtime add table messages;
