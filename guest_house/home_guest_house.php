<link href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">

<div style='padding: 17px'>
<h2>Home Guest House Page</h2>
</div>

<?php
    session_start();

    if(isset($_SESSION['admin_logged_in']) && $_SESSION['admin_logged_in']){
?>
        <div class="form-group">
            <div class="col-md">
                <a href="monthlyBookings.php" class="btn btn-primary">Monthly Bookings</a>
                <a href="expenditure.php" class="btn btn-primary">Monthly Expenditure</a>
                <a href="bill.php" class="btn btn-primary">Generate Bills</a>
                <a href="foodBill.php" class="btn btn-primary">Monthly Food Bill</a>
                <a href="schedule.php" class="btn btn-primary">Staff Schedule</a><br><br>
                <a href="logout.php" class="btn btn-primary">Log Out</a>
            </div>
        </div>
<?php
        return;
    }
?>

<div class="col-md-8">
    <a href="admin_login.php" class="btn btn-primary">Admin Login</a>
    <a href="new_booking.php" class="btn btn-primary">New Booking</a>
    <a href="roomAvailability.php" class="btn btn-primary">Room Availability</a>
    <a href="../index.php" class="btn btn-primary">Go Back</a>
</div>