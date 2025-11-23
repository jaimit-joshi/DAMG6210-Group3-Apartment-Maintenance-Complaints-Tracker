# Supabase SQL Setup Instructions

## Step 1: Run the Schema Creation Script

1. Go to [Supabase Dashboard](https://app.supabase.com)
2. Click on your project
3. Go to **SQL Editor** (left sidebar)
4. Click **New Query**
5. Copy the entire contents of `scripts/supabase-schema.sql`
6. Paste it into the query editor
7. Click the blue **Run** button
8. Wait for success message

## Step 2: Seed the Database with Sample Data

1. In SQL Editor, click **New Query** again
2. Copy the entire contents of `scripts/supabase-seed-data.sql`
3. Paste it into the query editor
4. Click the blue **Run** button
5. Wait for success message

## Step 3: Verify Data was Inserted

\`\`\`sql
SELECT COUNT(*) as total_buildings FROM building;
SELECT COUNT(*) as total_residents FROM resident;
SELECT COUNT(*) as total_leases FROM lease;
SELECT COUNT(*) as total_work_orders FROM work_order;
\`\`\`

All counts should be greater than 0.

## Connection Details

Your Supabase connection is already configured in:
- `lib/supabase.ts` - Client configuration
- `app/api/*/route.ts` - All API endpoints

No additional setup needed once the SQL scripts are run!

## Troubleshooting

**Error: "Relation already exists"**
- The tables already exist. Delete and recreate them by running the schema script again.

**Error: "Foreign key constraint violated"**
- Insert data in the correct order. The seed script handles this automatically.

**No data showing on pages**
- Verify the seed script ran successfully
- Check that `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_ANON_KEY` are set in `.env.local`
