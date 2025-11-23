# Complete Database Setup Guide for Supabase

## Step 1: Install the Missing Dependency

Run this command in your terminal:

\`\`\`bash
npm install react-is
\`\`\`

Then restart your dev server:

\`\`\`bash
npm run dev
\`\`\`

## Step 2: Run the Setup SQL Script in Supabase

1. **Go to your Supabase project**: https://app.supabase.com/
2. **Navigate to SQL Editor** (left sidebar)
3. **Create a new query** and copy ALL the code from `scripts/setup-supabase.sql`
4. **Run the query** (click the blue play button)
5. Wait for success message

## Step 3: Populate Database with Sample Data

1. **In Supabase SQL Editor**, create a NEW query
2. **Copy ALL the code from `scripts/seed-data.sql`**
3. **Run the query** (click the blue play button)
4. Wait for success message

## Step 4: Verify Your Environment Variables

Check that `.env.local` has these 3 variables:

\`\`\`
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key-here
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key-here
\`\`\`

If any are missing:
- Go to Supabase Settings → API
- Copy the correct values
- Update `.env.local`
- Restart the dev server

## Step 5: Test Your App

1. **Restart the dev server**:
   \`\`\`bash
   npm run dev
   \`\`\`

2. **Open http://localhost:3000/buildings**
   - You should see 5 buildings listed
   - If not, check the error message in the page

3. **Try the dashboard**: http://localhost:3000/dashboard
   - Charts should now load without errors

## Troubleshooting

### Still no data showing?

1. **Check if SQL scripts ran successfully**:
   - In Supabase SQL Editor, click "Scripts" tab
   - Verify both scripts show as "Success"

2. **Check environment variables**:
   - Print them: `cat .env.local`
   - Make sure there are no typos or extra spaces

3. **Clear browser cache**:
   - Press `Ctrl+Shift+Delete` (or `Cmd+Shift+Delete` on Mac)
   - Clear all cache
   - Reload the page

4. **Check browser console for errors**:
   - Press `F12` to open developer tools
   - Look at Console tab for error messages
   - Screenshot the errors and share them

### Dashboard still crashing?

The `react-is` package should have fixed this. If not:

\`\`\`bash
npm install --legacy-peer-deps
npm run dev
\`\`\`

## Common Issues

| Issue | Solution |
|-------|----------|
| "Cannot find module 'react-is'" | Run `npm install react-is` |
| "0 buildings returned" | Run the seed-data.sql script in Supabase |
| "API error" in page | Check .env.local variables are correct |
| Charts not loading | Make sure `react-is` is installed |
| "Connection refused" | Verify NEXT_PUBLIC_SUPABASE_URL is correct |

## Need Help?

If you've completed all steps and still have issues:
1. Share the error message from the page
2. Share the console errors (F12 → Console)
3. Verify .env.local has all 3 variables
4. Double-check both SQL scripts ran successfully in Supabase
