import { createClient } from "@/lib/supabase/server"
import { type NextRequest, NextResponse } from "next/server"

export async function GET(req: NextRequest) {
  try {
    const supabase = await createClient()

    // Fetch all required data in parallel
    const [
      buildingsResult,
      residentsResult,
      unitsResult,
      leaseResult,
      paymentsResult,
      workOrdersResult,
      maintenanceResult,
      vendorsResult,
    ] = await Promise.all([
      supabase.from("building").select("*"),
      supabase.from("resident").select("*"),
      supabase.from("apartment_unit").select("*"),
      supabase.from("lease").select("*"),
      supabase.from("payment_transaction").select("*"),
      supabase.from("work_order").select("*"),
      supabase.from("maintenance_request").select("*"),
      supabase.from("vendor_company").select("*"),
    ])

    const buildings = buildingsResult.data || []
    const residents = residentsResult.data || []
    const units = unitsResult.data || []
    const leases = leaseResult.data || []
    const payments = paymentsResult.data || []
    const workOrders = workOrdersResult.data || []
    const maintenance = maintenanceResult.data || []
    const vendors = vendorsResult.data || []

    // Calculate statistics
    const totalBuildings = buildings.length
    const totalResidents = residents.length
    const totalUnits = units.length

    // Occupancy rate: count units with active leases
    const activeLeases = leases.filter((l) => l.lease_status === "Active" || l.lease_status === "Signed").length
    const occupancyRate = totalUnits > 0 ? Math.round((activeLeases / totalUnits) * 100) : 0

    // Total revenue: sum of all completed payments
    const totalRevenue = payments
      .filter((p) => p.transaction_status === "Completed")
      .reduce((sum, p) => sum + (p.amount_paid || 0), 0)

    // Pending work orders
    const pendingWorkOrders = workOrders.filter(
      (w) => w.work_status === "Pending" || w.work_status === "In Progress",
    ).length

    // Pending maintenance requests
    const pendingMaintenance = maintenance.filter(
      (m) => m.request_status !== "Completed" && m.request_status !== "Cancelled",
    ).length

    // Overdue payments
    const today = new Date().toISOString().split("T")[0]
    const overduePayments = payments.filter(
      (p) =>
        p.transaction_status === "Pending" &&
        p.due_date &&
        p.due_date < today &&
        (p.amount_paid || 0) < (p.amount_due || 0),
    ).length

    // Upcoming lease expirations (next 30 days)
    const thirtyDaysFromNow = new Date()
    thirtyDaysFromNow.setDate(thirtyDaysFromNow.getDate() + 30)
    const thirtyDaysFromNowStr = thirtyDaysFromNow.toISOString().split("T")[0]

    const upcomingExpirations = leases.filter(
      (l) =>
        l.lease_status === "Active" &&
        l.lease_end_date &&
        l.lease_end_date <= thirtyDaysFromNowStr &&
        l.lease_end_date >= today,
    ).length

    // Active leases
    const totalActiveLeases = activeLeases

    // Total vendors
    const totalVendors = vendors.length

    return NextResponse.json({
      totalBuildings,
      totalResidents,
      totalUnits,
      occupancyRate,
      totalRevenue: Math.round(totalRevenue * 100) / 100,
      pendingWorkOrders,
      pendingMaintenance,
      overduePayments,
      upcomingExpirations,
      totalActiveLeases,
      totalVendors,
    })
  } catch (error) {
    console.error("[v0] Error fetching stats:", error)
    return NextResponse.json(
      {
        error: "Failed to fetch statistics",
        totalBuildings: 0,
        totalResidents: 0,
        totalUnits: 0,
        occupancyRate: 0,
        totalRevenue: 0,
        pendingWorkOrders: 0,
        pendingMaintenance: 0,
        overduePayments: 0,
        upcomingExpirations: 0,
        totalActiveLeases: 0,
        totalVendors: 0,
      },
      { status: 500 },
    )
  }
}
