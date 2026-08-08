async function loadEvents() {

    const container = document.getElementById("events-container");

    container.innerHTML = "<p>Loading events...</p>";

    try {

        const response = await apiRequest("/events");

        if (!response.success) {

            container.innerHTML = `
                <div class="card">
                    <h2>Unable to load events</h2>
                    <p>Please try again later.</p>
                </div>
            `;

            return;
        }

        if (response.data.length === 0) {

            container.innerHTML = `
                <div class="card">
                    <h2>No Events Available</h2>
                    <p>There are currently no events.</p>
                </div>
            `;

            return;
        }

        container.innerHTML = "";

        response.data.forEach(event => {

            container.innerHTML += `

                <div class="event-card">

                    <h2>${event.title}</h2>

                    <div class="event-info">

                        <p>📅 ${event.date}</p>

                        <p>📍 ${event.location}</p>

                    </div>

                    <p class="description">

                        ${event.description}

                    </p>

                    <button
                        onclick="register('${event.event_id}')">

                        Register

                    </button>

                </div>

            `;

        });

    }

    catch (error) {

        console.error(error);

        container.innerHTML = `
            <div class="card">
                <h2>Error</h2>
                <p>Failed to connect to the API.</p>
            </div>
        `;

    }

}

function register(eventId) {

    window.location.href =
        `registrations.html?event=${eventId}`;
    window.location.href =
        `register.html?event=${eventId}`;

}

loadEvents();