CC := gcc
LD := gcc

MAKE := make

CFLAGS += -Wall -Winline
CFLAGS += -O3

LDFLAGS += -lpthread -ltcmalloc_minimal

.PHONY: all clean

BINS = benchmark_list_spinlock      \
       benchmark_list_rcu           \
       benchmark_list_rlu           \
       benchmark_list_harris        \
       benchmark_list_vlist         \
       benchmark_list_swisstm       \
       benchmark_list_move_spinlock \
       benchmark_list_move_rlu      \
       benchmark_list_move_vlist    \
       benchmark_list_move_swisstm  \
       benchmark_tree_prcu_eer      \
       benchmark_tree_prcu_d        \
       benchmark_tree_prcu_deer     \
       benchmark_tree_rcu           \
       benchmark_tree_rlu           \
       benchmark_tree_vtree         \
       benchmark_tree_bonsai        \
       benchmark_tree_vrbtree       \
       benchmark_tree_swisstm

all: $(BINS)

benchmark_list.o: benchmark_list.c benchmark_list.h
	$(CC) $(CFLAGS) -c -o $@ $<

# LIST

list_spinlock.o: list_spinlock.c benchmark_list.h
	$(CC) $(CFLAGS) -c -o $@ $<

list_rcu.o: list_rcu.c benchmark_list.h
	$(CC) $(CFLAGS) -c -o $@ $<

rlu.o: rlu.c rlu.h
	$(CC) $(CFLAGS) -c -o $@ $<

list_rlu.o: list_rlu.c benchmark_list.h rlu.h
	$(CC) $(CFLAGS) -c -o $@ $<

qsbr.o: qsbr.c qsbr.h util.h
	$(CC) $(CFLAGS) -c -o $@ $<

list_harris.o: list_harris.c benchmark_list.h util.h
	$(CC) $(CFLAGS) -c -o $@ $<

list_vlist.o: list_vlist.c benchmark_list.h util.h
	$(CC) $(CFLAGS) -c -o $@ $<

benchmark_list_spinlock: benchmark_list.o list_spinlock.o
	$(LD) -o $@ $^ $(LDFLAGS)

benchmark_list_rcu: benchmark_list.o list_rcu.o
	$(LD) -o $@ $^ $(LDFLAGS)

benchmark_list_rlu: benchmark_list.o list_rlu.o rlu.o
	$(LD) -o $@ $^ $(LDFLAGS)

benchmark_list_harris: benchmark_list.o list_harris.o qsbr.o
	$(LD) -o $@ $^ $(LDFLAGS)

benchmark_list_vlist: benchmark_list.o list_vlist.o qsbr.o
	$(LD) -o $@ $^ $(LDFLAGS)

benchmark_list_swisstm:
	cd swisstm && $(MAKE) target/obj/intset-list
	cp swisstm/target/obj/intset-list $@

# LIST MOVE

benchmark_list_move.o: benchmark_list_move.c benchmark_list_move.h
	$(CC) $(CFLAGS) -c -o $@ $<

list_move_spinlock.o: list_move_spinlock.c benchmark_list_move.h
	$(CC) $(CFLAGS) -c -o $@ $<

list_move_rlu.o: list_move_rlu.c benchmark_list_move.h
	$(CC) $(CFLAGS) -c -o $@ $<

list_move_vlist.o: list_move_vlist.c benchmark_list_move.h
	$(CC) $(CFLAGS) -c -o $@ $<

benchmark_list_move_spinlock: benchmark_list_move.o list_move_spinlock.o
	$(LD) -o $@ $^ $(LDFLAGS)

benchmark_list_move_rlu: benchmark_list_move.o list_move_rlu.o rlu.o
	$(LD) -o $@ $^ $(LDFLAGS)

benchmark_list_move_vlist: benchmark_list_move.o list_move_vlist.o qsbr.o
	$(LD) -o $@ $^ $(LDFLAGS)

benchmark_list_move_swisstm:
	cd swisstm && $(MAKE) target/obj/intset-list-mv
	cp swisstm/target/obj/intset-list-mv $@

# NON-BALANCED TREE

tree_prcu_eer.o: tree_prcu.c benchmark_list.h
	$(CC) $(CFLAGS) -DPRCU_EER -c -o $@ $<

tree_prcu_d.o: tree_prcu.c benchmark_list.h
	$(CC) $(CFLAGS) -DPRCU_D -c -o $@ $<

tree_prcu_deer.o: tree_prcu.c benchmark_list.h
	$(CC) $(CFLAGS) -DPRCU_DEER -c -o $@ $<

tree_rcu.o: tree_rcu.c benchmark_list.h
	$(CC) $(CFLAGS) -c -o $@ $<

tree_rlu.o: tree_rlu.c benchmark_list.h
	$(CC) $(CFLAGS) -c -o $@ $<

tree_vtree.o: tree_vtree.c benchmark_list.h
	$(CC) $(CFLAGS) -c -o $@ $<

benchmark_tree_prcu_eer: benchmark_list.o tree_prcu_eer.o
	$(LD) -o $@ $^ $(LDFLAGS)

benchmark_tree_prcu_d: benchmark_list.o tree_prcu_d.o
	$(LD) -o $@ $^ $(LDFLAGS)

benchmark_tree_prcu_deer: benchmark_list.o tree_prcu_deer.o
	$(LD) -o $@ $^ $(LDFLAGS)

benchmark_tree_rcu: benchmark_list.o tree_rcu.o
	$(LD) -o $@ $^ $(LDFLAGS)

benchmark_tree_rlu: benchmark_list.o tree_rlu.o rlu.o
	$(LD) -o $@ $^ $(LDFLAGS)

benchmark_tree_vtree: benchmark_list.o tree_vtree.o qsbr.o
	$(LD) -o $@ $^ $(LDFLAGS)

# BALANCED TREE

tree_bonsai.o: tree_bonsai.c benchmark_list.h
	$(CC) $(CFLAGS) -c -o $@ $<

tree_vrbtree.o: tree_vrbtree.c benchmark_list.h
	$(CC) $(CFLAGS) -c -o $@ $<

benchmark_tree_bonsai: benchmark_list.o tree_bonsai.o
	$(LD) -o $@ $^ $(LDFLAGS)

benchmark_tree_vrbtree: benchmark_list.o tree_vrbtree.o qsbr.o
	$(LD) -o $@ $^ $(LDFLAGS)

benchmark_tree_swisstm:
	cd swisstm && $(MAKE) target/obj/intset-tree
	cp swisstm/target/obj/intset-tree $@

clean:
	cd swisstm && $(MAKE) clean
	rm -f $(BINS) *.o
