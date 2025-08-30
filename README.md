# Fleet Scheduling iOS App

---
## Description

This app solves the **electric truck fleet scheduling problem**, optimizing truck charging across available chargers within a time limit.  
It uses a **greedy scheduling algorithm**:

1. Sort trucks by remaining energy needed.
2. Assign trucks to chargers with available capacity within the time limit.
3. Mark unassigned trucks when no suitable charger is available.

Built using **MVVM-C**, this structure includes:

- **Model**: Data structures (`Truck.swift`, `Charger.swift`) and `ScheduleService.swift`.
- **ViewModel**: `FleetScheduleViewModel.swift` to interface between UI and logic.
- **Coordinator**: `MainCoordinator.swift` for app flow/navigation.
- **View**: `ViewController.swift` handling display of schedules in a table.
- **Service**: `SchedulingService.swift` handling main scheduling logic.
- **UITests**: used XCTests for uinit testing 

---

## Screenshots

<table>
  <tr>
    <th>Main Screen</th>
    <th>Truck List</th>
    <th>Charger List</th>
  </tr>
  <tr>
    <td><img src="FleetScheduling-Chandan/Screenshots/Simulator%20Screenshot%20-%20iPhone%2016%20Pro%20-%202025-08-30%20at%2011.47.42.png" width="250"></td>
    <td><img src="FleetScheduling-Chandan/Screenshots/Simulator%20Screenshot%20-%20iPhone%2016%20Pro%20-%202025-08-30%20at%2011.47.49.png" width="250"></td>
    <td><img src="FleetScheduling-Chandan/Screenshots/Simulator%20Screenshot%20-%20iPhone%2016%20Pro%20-%202025-08-30%20at%2011.48.11.png" width="250"></td>
  </tr>
</table>

---

## Scheduled

<table>
  <tr>
    <th>Scheduling Screen</th>
    <th>Truck Assigned to Charger</th>
  </tr>
  <tr>
    <td><img src="FleetScheduling-Chandan/Screenshots/Simulator%20Screenshot%20-%20iPhone%2016%20Pro%20-%202025-08-30%20at%2011.48.15.png" width="250"></td>
    <td><img src="FleetScheduling-Chandan/Screenshots/Simulator%20Screenshot%20-%20iPhone%2016%20Pro%20-%202025-08-30%20at%2011.48.17.png" width="250"></td>
  </tr>
</table>
---
