import jwt from 'jsonwebtoken';
import jwksClient from 'jwks-rsa';

export async function handler(event) {
  try {
    await authorize(event);
    console.log('authorization succeeded.');
    return { isAuthorized: true };
  } catch (err) {
    console.error('authorization failed.');
    console.error(err);
    return { isAuthorized: false };
  }
}

async function authorize(event) {
  const authorization = event.identitySource[0];
  const bearerPrefix = 'Bearer ';

  if (!authorization.startsWith(bearerPrefix)) {
    throw new Error(
      'Invalid authorization header; does not start with Bearer prefix.'
    );
  }

  const token = authorization.substring(
    bearerPrefix.length,
    authorization.length
  );
  const decoded = jwt.decode(token, { complete: true });

  if (!decoded) {
    throw new Error('Invalid authorization header; unable to read token.');
  }

  const { kid } = decoded.header;

  if (!kid) {
    throw new Error('Invalid token; no key identifier found.');
  }

  const { iss, sub } = decoded.payload;

  if (!iss) {
    throw new Error('Invalid token; no issuer found.');
  }

  const { routeKey } = event;

  await validateJwt(token, kid, sub, iss, routeKey);
}

async function validateJwt(token, kid, sub, validIssuer, routeKey) {
  console.log(`validating token with sub ${sub}.`);
  const scopesByRoute = new Map([
    [
      'GET /weather',
      'example-api/read:weather',
    ]
  ]);
  const requiredScope = scopesByRoute.get(routeKey);

  if (!requiredScope) {
    throw new Error(
      `route ${routeKey} has not been configured for authorization.`
    );
  }

  const payload = await verifyToken(token, kid, validIssuer);
  const scopes = payload.scope.split(/[\s,]+/);

  if (!scopes.includes(requiredScope)) {
    throw new Error(
      `invalid token; does not have the required scope ${requiredScope}.`
    );
  }
}

async function verifyToken(token, kid, issuer) {
  const jwksUri = `${issuer.replace(/\/+$/, '')}/.well-known/jwks.json`;
  const client = jwksClient({ jwksUri });
  const key = await client.getSigningKey(kid);
  const signingKey = key.getPublicKey();
  const payload = jwt.verify(token, signingKey, { issuer });

  return payload;
}
