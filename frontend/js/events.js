async function loadEvents() {

    const response = await apiRequest("/events");

    const container = document.getElementById("events-container");

    container.innerHTML = "";

    if (!response.success) {

        container.innerHTML = "<p>Unable to load events.</p>";

        return;
    }

    response.data.forEach(event => {

        container.innerHTML += `

            <div class="card">

                <h2>${event.title}</h2>

                <p><strong>Date:</strong> ${event.date}</p>

                <p><strong>Location:</strong> ${event.location}</p>

                <p>${event.description}</p>

                <button onclick="register('${event.event_id}')">
                    Register
                </button>

            </div>

        `;

    });

}

function register(eventId) {

    window.location.href =
        `registrations.html?event=${eventId}`;

}

loadEvents();