class BetterSafeState implements State {
    private int[] value;
    private Object[] lock;
    
    BetterSafeState(int[] v) { 
	value = v;
	lock = new Object[v.length];
	for (int i=0; i<v.length; i++)
	    lock[i] = new Object();
    }

    public int size() { return value.length; }

    public int[] current() { return value; }

    public boolean swap(int i, int j) {
	synchronized (lock[i]) {
	    if (value[i] <= 0) {
		return false;
	    }
	    value[i]--;
	}
	synchronized (lock[j]) {
	    value[j]++;
	}
	return true;
    }
}


/*
import java.util.concurrent.locks.ReentrantLock;

class BetterSafeState implements State {
    private int[] value;
    private ReentrantLock[] lock;
    
    BetterSafeState(int[] v) { 
	value = v;
	lock = new ReentrantLock[v.length];
	for (int i=0; i<v.length; i++)
	    lock[i] = new ReentrantLock();
    }

    public int size() { return value.length; }

    public int[] current() { return value; }

    public boolean swap(int i, int j) {
	if (lock[i].tryLock()) {
	    if (value[i] <= 0) {
	        lock[i].unlock();
		return false;
	    }
	    value[i]--;
	    lock[i].unlock();
	    lock[j].lock();
	    value[j]++;
	    lock[j].unlock();
	    return true;
	}
	else
	    return false;
    }
}
*/
