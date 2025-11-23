export interface Building {
  BuildingID: number
  BuildingName: string
  StreetAddress: string
  City: string
  State: string
  ZipCode: string
  YearBuilt: number
  NumberOfFloors: number
  TotalUnits: number
  BuildingType: string
  HasElevator: boolean
  CreatedDate: Date
  ModifiedDate: Date
}

export interface ApartmentUnit {
  UnitID: number
  BuildingID: number
  UnitNumber: string
  FloorNumber: number
  UnitType: string
  SquareFootage: number
  NumberBedrooms: number
  NumberBathrooms: number
  BaseRentAmount: number
  UnitStatus: string
  CreatedDate: Date
  ModifiedDate: Date
}

export interface Resident {
  ResidentID: number
  FirstName: string
  LastName: string
  DateOfBirth: Date
  SSNLast4: string
  PrimaryPhone: string
  AlternatePhone?: string
  EmailAddress: string
  CurrentAddress: string
  AccountStatus: string
  BackgroundCheckStatus?: string
  BackgroundCheckDate?: Date
  CreditScore?: number
  CreatedDate: Date
  ModifiedDate: Date
}

export interface Lease {
  LeaseID: number
  ResidentID: number
  UnitID: number
  PreparedByManagerID: number
  LeaseStartDate: Date
  LeaseEndDate: Date
  MonthlyRentAmount: number
  SecurityDepositAmount: number
  PetDepositAmount: number
  PaymentDueDay: number
  LateFeeAmount: number
  GracePeriodDays: number
  LeaseStatus: string
  SignedDate?: Date
  MoveInDate?: Date
  MoveOutDate?: Date
  TerminationReason?: string
  CreatedDate: Date
  ModifiedDate: Date
}

export interface MaintenanceRequest {
  RequestID: number
  ResidentID: number
  UnitID: number
  CategoryID: number
  RequestTitle: string
  RequestDescription: string
  RequestPriority: string
  RequestStatus: string
  SubmittedDate: Date
  AcknowledgedDate?: Date
  CompletedDate?: Date
  PermissionToEnter: boolean
  PetOnPremises: boolean
  CreatedDate: Date
  ModifiedDate: Date
}

export interface WorkOrder {
  WorkOrderID: number
  WorkOrderNumber: string
  RequestID?: number
  UnitID: number
  CreatedByManagerID: number
  VendorID?: number
  WorkType: string
  WorkDescription: string
  ScheduledDate?: Date
  StartDateTime?: Date
  CompletionDateTime?: Date
  WorkStatus: string
  EstimatedCost?: number
  ActualCost?: number
  RequiresApproval: boolean
  ApprovedByManagerID?: number
  ApprovalDate?: Date
  CreatedDate: Date
  ModifiedDate: Date
}

export interface Invoice {
  InvoiceID: string
  InvoiceNumber: string
  WorkOrderID: number
  VendorID: number
  ApprovedByManagerID?: number
  InvoiceDate: Date
  DueDate: Date
  LaborCost: number
  MaterialCost: number
  TaxAmount: number
  TotalAmount: number
  PaymentStatus: string
  PaymentDate?: Date
  PaymentMethod?: string
  PaymentReference?: string
  ApprovalDate?: Date
  CreatedDate: Date
  ModifiedDate: Date
}

export interface PropertyManager {
  ManagerID: number
  EmployeeID: string
  FirstName: string
  LastName: string
  EmailAddress: string
  PhoneNumber: string
  JobTitle: string
  Department?: string
  HireDate: Date
  ManagerRole: string
  MaxApprovalLimit?: number
  AccountStatus: string
  CreatedDate: Date
  ModifiedDate: Date
}

export interface VendorCompany {
  VendorID: number
  CompanyName: string
  TaxID: string
  PrimaryContactName: string
  PhoneNumber: string
  EmailAddress: string
  StreetAddress: string
  City: string
  State: string
  ZipCode: string
  LicenseNumber?: string
  LicenseExpiryDate?: Date
  InsurancePolicyNumber?: string
  InsuranceExpiryDate?: Date
  VendorStatus: string
  IsPreferred: boolean
  CreatedDate: Date
  ModifiedDate: Date
}

export interface PaymentTransaction {
  TransactionID: string
  LeaseID: number
  ResidentID: number
  TransactionType: string
  TransactionDate: Date
  DueDate?: Date
  AmountDue?: number
  AmountPaid: number
  PaymentMethod: string
  ReferenceNumber?: string
  TransactionStatus: string
  CreatedDate: Date
  ModifiedDate: Date
}
