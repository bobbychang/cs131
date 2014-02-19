import java.util.concurrent.atomic.AtomicInteger;
class BetterSorryState implements State {

    private AtomicInteger[] value;

    BetterSorryState(int[] v) { 
	value = new AtomicInteger[v.length];
	for (int i=0; i<v.length; i++) {
	    value[i] = new AtomicInteger(v[i]);
	}
    }
    public int size() { return value.length; }

    public int[] current() { 
	int[] current = new int[value.length];
	for (int i=0; i < value.length; i++)
	    current[i] = value[i].get();
	return current; 
    }

    public boolean swap(int i, int j) {
	if (value[i].get() <= 0) {
	    return false;
	}
	value[i].set(value[i].get()-1);
	value[j].set(value[j].get()+1);
	return true;
    }
}
/*
import java.util.concurrent.locks.ReentrantLock;
class BetterSorryState implements State {
    private int[] value;
    private ReentrantLock[] lock;

    BetterSorryState(int[] v) {
        value = v;
	lock = new ReentrantLock[v.length];
	for (int i=0; i<v.length; i++)
	    lock[i] = new ReentrantLock();     
    }
    public int size() { return value.length; }
    public int[] current() { return value; }

    public boolean swap(int i, int j) {
	if (value[i] <= 0) {
	    return false;
	}
	lock[i].lock();
	value[i]--;
	lock[i].unlock();

	lock[j].lock();	
	value[j]++;
	lock[j].unlock();

	return true;
    }
}
*/
/*
class BetterSorryState implements State {
    private int[] value;
    private Object[] lock;

    BetterSorryState(int[] v) {
        value = v;
	lock = new Object[v.length];
	for (int i=0; i<v.length; i++)
	    lock[i] = new Object();     
    }
    public int size() { return value.length; }
    public int[] current() { return value; }

    public boolean swap(int i, int j) {
	if (value[i] <= 0) {
	    return false;
	}
	synchronized (lock[i]) {
	    value[i]--;
	}
	synchronized (lock[j]) {
	    value[j]++;
	}
	return true;
    }
}
*/
/*
import java.util.concurrent.atomic.AtomicIntegerArray;

class BetterSorryState implements State {
    private AtomicIntegerArray value;

    BetterSorryState(int[] v) { value = new AtomicIntegerArray(v); }

    public int size() { return value.length(); }

    public int[] current() { 
        int[] current = new int[value.length()];
	for (int i=0; i<current.length;i++)
            current[i] = value.get(i);
        return current;
    }

    public boolean swap(int i, int j) {
	if (value.get(i) <= 0) {
	    return false;
	}
	value.getAndDecrement(i);
	value.getAndIncrement(j);
	//value.decrementAndGet(i);
	//value.incrementAndGet(j);
	
	return true;
    }
}
*/
