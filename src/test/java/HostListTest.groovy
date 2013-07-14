import static org.junit.Assert.*

import org.junit.Test

class HostListTest {

	@Test
	public void test() {

		println HostList.total();

		assertEquals(7, HostList.total().size)
	}
}
