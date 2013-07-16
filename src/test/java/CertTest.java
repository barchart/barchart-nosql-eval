import java.io.File;
import java.io.IOException;
import java.net.UnknownHostException;
import java.security.cert.Certificate;

import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLSocket;
import javax.net.ssl.SSLSocketFactory;

public class CertTest {

	public static void main(final String[] args) throws UnknownHostException,
			IOException {

		final String hostname = "opsc.cassandra.aws.barchart.com";
		// final int port = 8443;
		final int port = 61620;
		// final int port = 61621;

		System.setProperty("javax.net.debug", "ssl");

		final String store = new File("src/test/resources/agentKeyStore")
				.getAbsolutePath();

		System.setProperty("javax.net.ssl.trustStore", store);
		System.setProperty("javax.net.ssl.keyStore", store);
		System.setProperty("javax.net.ssl.keyStorePassword", "opscenter");

		final SSLSocketFactory factory = HttpsURLConnection
				.getDefaultSSLSocketFactory();

		final SSLSocket socket = (SSLSocket) factory.createSocket(hostname,
				port);

		socket.startHandshake();

		System.out.println("===============");

		final Certificate[] serverCerts = socket.getSession()
				.getPeerCertificates();

		System.out.println("number of found certificates: "
				+ serverCerts.length);

		System.out.println("===============");

		for (final Certificate certificate : serverCerts) {
			System.out.println(certificate.getPublicKey());
			System.out.println(certificate);
			System.out.println("===============");
		}

		socket.close();

	}

}
