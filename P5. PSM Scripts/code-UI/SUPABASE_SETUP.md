# ApartHub - Supabase Setup Guide

This guide walks you through setting up your apartment management system with Supabase PostgreSQL database.

## Step 1: Create Supabase Account & Project

1. **Go to [supabase.com](https://supabase.com)**
2. **Click "Start your project"** (or sign in if you have an account)
3. **Create a new project:**
   - Organization: Create new or select existing
   - Project name: `apartment-management` (or your choice)
   - Database password: **Create a strong password and save it**
   - Region: Select the closest region to you
   - Pricing plan: Start (free tier)

4. **Click "Create new project"**
   - Wait 2-3 minutes for the database to be provisioned

## Step 2: Get Your API Keys

1. **In Supabase dashboard, go to Settings → API**
2. **Copy these three values:**
   - **Project URL**: Under "Project API keys" (looks like `https://your-project.supabase.co`)
   - **Anon Key**: Under "Project API keys" (public key, safe to expose in browser)
   - **Service Role Key**: Under "Project API keys" (keep this secret!)

## Step 3: Update Environment Variables

Create or update `.env.local` in your project root:

\`\`\`bash
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key-here
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key-here
\`\`\`

**Note:** 
- `NEXT_PUBLIC_*` variables are exposed in the browser (safe to use public anon key)
- Service role key stays on server only

## Step 4: Set Up Database Schema

1. **In Supabase dashboard, click "SQL Editor"** (left sidebar)
2. **Click "New Query"**
3. **Copy the entire content from `scripts/setup-supabase.sql`**
4. **Paste it into the SQL Editor**
5. **Click "Run"** or press `Ctrl+Enter`
6. **Wait for the query to complete** (you'll see a success message)

This creates all 12 tables with proper relationships and indexes.

## Step 5: Install Dependencies

\`\`\`bash
npm install @supabase/supabase-js
\`\`\`

## Step 6: Test the Connection

\`\`\`bash
npm run dev
\`\`\`

Then navigate to:
- **http://localhost:3000/buildings** - Should load buildings (might be empty initially)
- **Click "Add Building"** - Test creating a new building

If successful, you'll see the building appear in the table!

## Step 7: Optional - Add Sample Data

You can add sample data through the UI or run this SQL in Supabase SQL Editor:

\`\`\`sql
-- Add a sample building
INSERT INTO building (building_name, street_address, city, state, zip_code, year_built, number_of_floors, total_units, building_type, has_elevator)
VALUES ('Downtown Plaza', '123 Main St', 'New York', 'NY', '10001', 2015, 25, 150, 'Residential', true);

-- Add a sample property manager
INSERT INTO property_manager (employee_id, first_name, last_name, email_address, phone_number, job_title, manager_role)
VALUES ('PM001', 'John', 'Smith', 'john@example.com', '5551234567', 'Building Manager', 'Manager');

-- Add a sample resident
INSERT INTO resident (first_name, last_name, date_of_birth, primary_phone, email_address)
VALUES ('Jane', 'Doe', '1990-01-15', '5559876543', 'jane@example.com');
\`\`\`

## Troubleshooting

### "Connection refused" or "Network error"
- Check that `.env.local` has correct `NEXT_PUBLIC_SUPABASE_URL`
- Verify you copied the exact URL from Supabase dashboard

### "Invalid API key"
- Copy the anon key again from Supabase Settings → API
- Make sure you didn't accidentally include spaces

### "Table not found" error
- Run the SQL schema setup script again in Supabase SQL Editor
- Confirm the SQL executed successfully

### Data not showing in UI
- Check browser console (F12) for errors
- Verify the table names match the SQL script (all lowercase with underscores)
- Test with Supabase dashboard to confirm data exists

## Supabase Features You Can Use

1. **Real-time Updates**: Subscribe to table changes
2. **Authentication**: Add built-in user login
3. **Row Level Security**: Control who can see what data
4. **Backups**: Automatic daily backups
5. **Vector Search**: AI-powered search (future enhancement)

## Useful Links

- [Supabase Docs](https://supabase.com/docs)
- [JavaScript Client Reference](https://supabase.com/docs/reference/javascript/introduction)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

## Next Steps

1. Start using the app - create buildings, residents, leases, work orders
2. Deploy to Vercel for free with `vercel deploy`
3. Add authentication with Supabase Auth (optional)
4. Set up Row Level Security for multi-tenant support (optional)
