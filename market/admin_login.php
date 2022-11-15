<link href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">

<?php
    require_once "db.php";
    session_start();

    if (isset($_POST['empid']) && isset($_POST['password'])) {
        unset($_SESSION['admin_logged_in']);
        if ($_POST['empid'] == 'admin_market' && $_POST['password'] == "12345") {
            $_SESSION['admin_logged_in'] = true;
            header('Location: home_market.php');
        }
        else{
            $_SESSION['login_failed'] = "Incorrect Credentials, Please try again!!";
            header('Location: admin_login.php');
        }
        return;
    }
?>

<div class="row align-items-center justify-content-center" style="height:80vh;">
<div class="col-md-8">
                <div class="card">
                    <div class="card-header">Market Admin Login</div>
                    
                    <div class="card-body">
<?php
                    if (isset($_SESSION['login_failed'])) {
                        echo('<p style="color:red">'.$_SESSION['login_failed'].'</p>'."\n");
                        unset($_SESSION['login_failed']);
                    }
?>
                        <form method="post">
                            <div class="form-group row">
                                <label for="empid" class="col-md-4 col-form-label text-md-right">Employee ID</label>
                                <div class="col-md-6">
                                    <input type="text" class="form-control" name="empid" required autofocus>
                                </div>
                            </div>

                            <div class="form-group row">
                                <label for="password" class="col-md-4 col-form-label text-md-right">Password</label>
                                <div class="col-md-6">
                                    <input type="password" class="form-control" name="password" required>
                                </div>
                            </div>

                            <div class="col-md-6 offset-md-4">
                                <button type="submit" class="btn btn-primary">
                                    Login
                                </button>
                                <a href="home_market.php" class="btn btn-link">
                                    Go Back 
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
</div>
</div>