"use client"

import { useEffect, useState } from "react"
import { Card, CardContent } from "@/components/ui/card"

export default function Dashboard() {
  const [tableCounts, setTableCounts] = useState({
    buildings: 0,
    units: 0,
    residents: 0,
    leases: 0,
    managers: 0,
    vendors: 0,
    workers: 0,
    maintenance: 0,
    workOrders: 0,
    invoices: 0,
    payments: 0,
    amenities: 0,
    buildingAmenities: 0,
    unitAmenities: 0,
    maintenanceCategories: 0,
    emergencyContacts: 0,
    leaseOccupants: 0,
    managerAssignments: 0,
    workerAssignments: 0,
    escalations: 0,
    notifications: 0,
  })

  useEffect(() => {
    fetchAllCounts()
  }, [])

  async function fetchAllCounts() {
    try {
      const [
        buildings,
        units,
        residents,
        leases,
        managers,
        vendors,
        workers,
        maintenance,
        workOrders,
        invoices,
        payments,
        amenities,
        buildingAmenities,
        unitAmenities,
        maintenanceCategories,
        emergencyContacts,
        leaseOccupants,
        managerAssignments,
        workerAssignments,
        escalations,
        notifications,
      ] = await Promise.all([
        fetch("/api/buildings").then((r) => r.json()),
        fetch("/api/units").then((r) => r.json()),
        fetch("/api/residents").then((r) => r.json()),
        fetch("/api/leases").then((r) => r.json()),
        fetch("/api/managers").then((r) => r.json()),
        fetch("/api/vendors").then((r) => r.json()),
        fetch("/api/workers").then((r) => r.json()),
        fetch("/api/maintenance").then((r) => r.json()),
        fetch("/api/work-orders").then((r) => r.json()),
        fetch("/api/invoices").then((r) => r.json()),
        fetch("/api/payments").then((r) => r.json()),
        fetch("/api/amenities").then((r) => r.json()),
        fetch("/api/building-amenities").then((r) => r.json()),
        fetch("/api/unit-amenities").then((r) => r.json()),
        fetch("/api/maintenance-categories").then((r) => r.json()),
        fetch("/api/emergency-contacts").then((r) => r.json()),
        fetch("/api/lease-occupants").then((r) => r.json()),
        fetch("/api/manager-assignments").then((r) => r.json()),
        fetch("/api/worker-assignments").then((r) => r.json()),
        fetch("/api/escalations").then((r) => r.json()),
        fetch("/api/notifications").then((r) => r.json()),
      ])

      setTableCounts({
        buildings: buildings.length,
        units: units.length,
        residents: residents.length,
        leases: leases.length,
        managers: managers.length,
        vendors: vendors.length,
        workers: workers.length,
        maintenance: maintenance.length,
        workOrders: workOrders.length,
        invoices: invoices.length,
        payments: payments.length,
        amenities: amenities.length,
        buildingAmenities: buildingAmenities.length,
        unitAmenities: unitAmenities.length,
        maintenanceCategories: maintenanceCategories.length,
        emergencyContacts: emergencyContacts.length,
        leaseOccupants: leaseOccupants.length,
        managerAssignments: managerAssignments.length,
        workerAssignments: workerAssignments.length,
        escalations: escalations.length,
        notifications: notifications.length,
      })
    } catch (error) {
      console.error("Error fetching counts:", error)
    }
  }

  const tableCards = [
    { label: "Buildings", count: tableCounts.buildings },
    { label: "Units", count: tableCounts.units },
    { label: "Residents", count: tableCounts.residents },
    { label: "Leases", count: tableCounts.leases },
    { label: "Managers", count: tableCounts.managers },
    { label: "Vendors", count: tableCounts.vendors },
    { label: "Workers", count: tableCounts.workers },
    { label: "Maintenance", count: tableCounts.maintenance },
    { label: "Work Orders", count: tableCounts.workOrders },
    { label: "Invoices", count: tableCounts.invoices },
    { label: "Payments", count: tableCounts.payments },
    { label: "Amenities", count: tableCounts.amenities },
    { label: "Building Amenities", count: tableCounts.buildingAmenities },
    { label: "Unit Amenities", count: tableCounts.unitAmenities },
    { label: "Maintenance Categories", count: tableCounts.maintenanceCategories },
    { label: "Emergency Contacts", count: tableCounts.emergencyContacts },
    { label: "Lease Occupants", count: tableCounts.leaseOccupants },
    { label: "Manager Assignments", count: tableCounts.managerAssignments },
    { label: "Worker Assignments", count: tableCounts.workerAssignments },
    { label: "Escalations", count: tableCounts.escalations },
    { label: "Notifications", count: tableCounts.notifications },
  ]

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-semibold">Dashboard</h1>
        <p className="text-muted-foreground mt-1">Overview of all 21 database tables</p>
      </div>

      <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-4">
        {tableCards.map((card, idx) => (
          <Card key={idx}>
            <CardContent className="pt-6">
              <p className="text-sm text-muted-foreground mb-1">{card.label}</p>
              <p className="text-3xl font-semibold">{card.count}</p>
            </CardContent>
          </Card>
        ))}
      </div>
    </div>
  )
}
