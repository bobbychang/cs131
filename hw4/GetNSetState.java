import java.util.concurrent.atomic.AtomicIntegerArray;

class GetNSetState implements State {
    private AtomicIntegerArray value;

    GetNSetState(int[] v) { value = new AtomicIntegerArray(v); }

    public int size() { return value.length(); }

    public int[] current() { 
	int[] current = new int[value.length()];
	for (int i=0; i<current.length; i++)
	    current[i] = value.get(i);
	return current; 
    }

    public boolean swap(int i, int j) {
	if (value.get(i) <= 0) {
	    return false;
	}
	value.set(i, value.get(i)-1);
	value.set(j, value.get(j)+1);
	return true;
    }
}
