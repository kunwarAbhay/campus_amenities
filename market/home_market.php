<link href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">

<style>
    body {
        background-image:  linear-gradient(#dddddd9e , #ffffff03) ,url(../images/market_photo.jpg);
        background-size: cover;
        backdrop-filter: blur(1px);
        height: 100vh;
        background-position: center;
    }

    .contributor{
        background-color: #fff;
    }
</style>

<div style='padding: 17px'>
<h2 class="text-center bg-white p-4 rounded">Home Market Page</h2>
</div>

<?php
    session_start();

    if(isset($_SESSION['admin_logged_in']) && $_SESSION['admin_logged_in']){
?>
        <div class="form-group">
            <label class="col-md-8 control-label"></label>
            <div class="col-md-8">
                <a href="shop.php" class="btn btn-primary">Shop Details</a>
                <a href="shopkeeper.php" class="btn btn-primary">Shopkeeper Details</a>
                <a href="reminder.php" class="btn btn-primary">License Expiration Reminder</a>
                <a href="performance.php" class="btn btn-primary">Shop Performance</a>
                <a href="pending_charge.php" class="btn btn-primary">Shop Pending Charges</a>
                <a href="available_plots.php" class="btn btn-primary">Available Plots</a><br><br>
                <a href="logout.php" class="btn btn-primary">Log Out</a>
            </div>
        </div>
<?php
        return;
    }
?>

<div class="container d-flex justify-content-between text-center">
    <a href="admin_login.php" class="btn btn-primary">Admin Login</a>
    <a href="feedback.php" class="btn btn-primary">Feedback</a>
    <a href="payment.php" class="btn btn-primary">Payment</a>
    <a href="../index.php" class="btn btn-primary">Go Back</a>
</div>