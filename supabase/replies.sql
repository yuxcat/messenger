create table replies (
  id integer generated always as identity,
  thread integer references public.posts not null,
  createdby uuid references auth.users not null,
  updated_at timestamp with time zone,
  title text,
  contents text,

  primary key (id)
  
);

alter table replies enable row level security;

create policy "Public profiles are viewable by everyone."
  on replies for select
  using ( true );

create policy "Users can insert their own reply."
  on replies for insert
  with check ( auth.uid() = createdby );

create policy "Users can update own reply."
  on replies for update
  using ( auth.uid() = createdby );

-- Set up Realtime!
begin;
  drop publication if exists supabase_realtime;
  create publication supabase_realtime;
commit;
alter publication supabase_realtime add table replies;
