import { Building2, Users, Wrench, DollarSign } from 'lucide-react'

export default function HomePage() {
  return (
    <div className="space-y-6">
      <div className="flex items-center gap-4">
        <div className="p-3 bg-primary rounded-xl shadow-lg shadow-primary/20">
          <Building2 className="text-primary-foreground" size={32} />
        </div>
        <div>
          <h1 className="text-3xl font-semibold">Welcome to ApartHub</h1>
          <p className="text-muted-foreground mt-1">
            A comprehensive property management system for buildings, residents, and maintenance.
          </p>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mt-8">
        <div className="p-6 border rounded-lg bg-card hover:shadow-lg transition-shadow">
          <div className="flex items-center gap-3 mb-3">
            <div className="p-2 bg-primary/10 rounded-lg">
              <Building2 className="text-primary" size={24} />
            </div>
            <h2 className="text-xl font-semibold">Property Management</h2>
          </div>
          <p className="text-sm text-muted-foreground">
            Manage buildings, units, and track occupancy rates across all your properties.
          </p>
        </div>

        <div className="p-6 border rounded-lg bg-card hover:shadow-lg transition-shadow">
          <div className="flex items-center gap-3 mb-3">
            <div className="p-2 bg-accent/10 rounded-lg">
              <Users className="text-accent" size={24} />
            </div>
            <h2 className="text-xl font-semibold">Resident Management</h2>
          </div>
          <p className="text-sm text-muted-foreground">
            Keep track of residents, leases, and rental payments in one centralized system.
          </p>
        </div>

        <div className="p-6 border rounded-lg bg-card hover:shadow-lg transition-shadow">
          <div className="flex items-center gap-3 mb-3">
            <div className="p-2 bg-primary/10 rounded-lg">
              <Wrench className="text-primary" size={24} />
            </div>
            <h2 className="text-xl font-semibold">Maintenance Tracking</h2>
          </div>
          <p className="text-sm text-muted-foreground">
            Monitor maintenance requests and work orders to ensure timely resolutions.
          </p>
        </div>

        <div className="p-6 border rounded-lg bg-card hover:shadow-lg transition-shadow">
          <div className="flex items-center gap-3 mb-3">
            <div className="p-2 bg-accent/10 rounded-lg">
              <DollarSign className="text-accent" size={24} />
            </div>
            <h2 className="text-xl font-semibold">Financial Overview</h2>
          </div>
          <p className="text-sm text-muted-foreground">
            Track invoices, payments, and revenue across all your managed properties.
          </p>
        </div>
      </div>
    </div>
  )
}
