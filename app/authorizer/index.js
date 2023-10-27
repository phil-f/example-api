export async function handler(event) {
    console.log("authorization starting.");
    const { authorization } = event.headers;
    if (authorization !== "supersecretpassword") {
        console.log("authorization failed.")
        return { isAuthorized: false };
    }
    console.log("authorization succeeded.");
    return { isAuthorized: true };
}
