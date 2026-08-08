const params = new URLSearchParams(window.location.search);

document.getElementById("event_id").value =
    params.get("event") || "";

document
    .getElementById("registration-form")
    .addEventListener("submit", registerEvent);

async function registerEvent(e) {

    e.preventDefault();

    const body = {

        event_id:
            document.getElementById("event_id").value,

        full_name:
            document.getElementById("full_name").value,

        email:
            document.getElementById("email").value

    };

    const response =
        await apiRequest(
            "/register",
            "POST",
            body
        );

    const message =
        document.getElementById("message");

    if (response.success) {

        message.innerHTML = `
            <div class="success">

                <h3>
                    Registration Successful!
                </h3>

                <p>${response.message}</p>

            </div>
        `;

        document
            .getElementById("registration-form")
            .reset();

    }

    else {

        message.innerHTML = `
            <div class="error">

                <h3>
                    Registration Failed
                </h3>

                <p>${response.message}</p>

            </div>
        `;

    }

}